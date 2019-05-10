#  syntax = 语法

-- ------------------------------------------第一章--------------------------------------
-------- ----------- DDL: data definition language=数据定义语言------------------
/*
主要是用来定义和维护数据库的各种对象（比如库、表、索引和视图等），也可以说操作的层次是在数据
库和表的逻辑结构和存储结构上面，
并没有对表中的实际的数据进行操作！

*/


#---------------创建数据库------------
--  syntax: create database 数据库名 [库选项];
create database qiming default charset utf8;

-- 修改数据库,不能通过命令修改数据库名,可以先把表数据导出,创建新数据库,导入数据表,再删除数据库
-- syntax : alter database 库名 库选项;
alter database qiming default charset utf8;

-- 删除数据库
-- syntax : drop database 库名;
drop database qiming;

#--------------创建表------------------

/*syntax : create table 表名(字段名 字段类型)[表选项];*/
create table person(
	id int,
	name varchar(10),
	score mediumint
)engine=INNODB default charset=utf8;


# ------------关于修改--------------
/*  PS: 改数据表的指令都可以分成 上级命令+下级命令来记忆，其中上级命令都是一样的
alter table 表名 ........
而下级命令只需要记忆一些关键字即可,比如: 
增加: add
删除: drop
重命名表名: rename
重命名字段名: change
修改: modify    

*/
-- 修改表名字,下级命令关键字: rename
-- syntax: alter table 表名 rename to 新表名;
alter table person rename to persons;
-- 修改表名的另一种方式
rename table persons to person;

#我们可以利用rename语法实现一个人数据库的数据表移动(剪切)到另一个数据库
-- 注意:剪切,代表这个数据表被剪走了,所以我们可以利用这个实现数据库重命名
--  1,创建新数据库; 2.在原数据库使用rename把表剪切过去; 3.删除旧数据库
-- syntax : rename table 表名 to 库名.表名;
rename table person to test.person;


#修改列定义
-- 增加一列 ,下级命令关键字:add
-- syntax: alter table 表名 add 字段名 字段类型;
alter table person add gender varchar(2);
-- 新增加的字段默认排在最后面,想排在前面需要加上first关键字
-- syntax: alter table 表名 add 字段名 字段类型 first;
alter table person add work varchar(10) first;
-- 如果想排在另外一个字段的后面
-- syntax: alter table 表名 add 字段名 字段类型 after 字段名;
alter table person add wages int after name;


#删除一列,下级命令关键字:drop
-- syntax: alter table 表名 drop 字段名;
alter table person drop wages;

#修改字段类型,下级命令关键字: modify
-- syntax : alter table 表名 modify 字段名 新的字段类型;
alter table person modify work varchar(5);
-- 修改已有字段的排序
-- syntax: alter table 表名 modify 字段名1 字段类型 after 字段名2;
-- syntax: alter table 表名 modify 字段名 字段类型 first;
alter table person modify work varchar(6) after name;

#重命名字段,下级命令关键字:change
-- syntax: alter table 表名 change 原字段名 新字段名 字段类型;
alter table person work works varchar(5);

#修改表选项
-- syntax: alter table 表名 新的表选项;
alter table person engine Myisam default charset gbk;










-- --------------------------------------第二章------------------------------------------------------------
-- ---------------- DML: data manipulation language = 数据操作语言--------------------------------------
-- 主要是对表中的记录进行增删改查的操作！其中，“查询”部分，又称为DQL（Data Query Language），数据查询语言！主要的操作关键字：insert、delete、update、select等
-- 先简单的创建一张表
create table student(
	stu_name varchar(10),
	stu_gender enum('male', 'female'),
	stu_age tinyint unsigned,
	stu_tel varchar(20)
);

#插入数据(增) 关键字:insert into 
-- syntax: insert into 表名(字段列表) values(值列表);
-- syntax: insert into 表名 values(值列表); #值和字段一一对应,不能缺少
-- syntax: insert into 表名 values(值列表1),
-- 								  (值列表2),
-- 								  (值列表3);
insert into student(stu_name, stu_gender) values('乌宝宝', 'male'); 
insert into student values('王昭君', 'female', 20, 123456789);
insert into student values('董小蔓', 'male', 12, 12358),
						  ('杨玉环', 'female', 24, 123456),
						  ('貂蝉', 'male', 25, 1233455555);
-- 另一种插入语法
-- syntax: insert into 表名 set 字段1=值1,字段2=值2.........
insert into student set stu_name = '虚伪', stu_age = 24;

#查询数据(查) ,关键字 : select
-- syntax: select *|字段列表 from 表名 [查询条件];
-- 查询所有,即使查询所有记录,建议也加上where 1
select * from student where 1;
select * from student stu_age > 20;

#删除数据(删),关键字: delete
-- syntax: delete from 表名 [删除条件];
delete from student where stu_age is null;

#修改数据(改),关键字:update
-- syntax: update 表名 set 字段1=值1,字段2=值2.... [修改条件];
update student set stu_age = stu_age + 1 where 1; #全部改了




-- ---------------------------------第三章,字符集-----------------------------------
# 查询当前mysql支持的字符集编码
show charset;

-- gbk：一个汉字占用2个字节！
-- utf8：一个汉字占用3个字节！

-- 告诉服务器,当前客户端使用的是gbk编码格式,在DOC(cmd)中,默认使用的就是gbk,而mysql使用的gbk
-- php 操作mysql呢,用什么字符集编码? 答: set names utf8;
set names gbk;





-- ---------------------------------第四章,校对规则-----------------------------------
-- 通过show collation命令来查看当前数据库有哪些排序规则：
show collation;


-- 如果只想看一utf8开头的字符集，可以使用模糊查询：
show collation like 'utf8_%';

/*
ci结尾的：不区分大小写（针对英文）
cs结尾的：区分大小写（针对英文）
bin结尾：二进制编码比较
*/

-- utf8不支持中文比较，但是gbk支持（比较拼音）
-- 修改校对规则
-- syntax: alter database 库名 default collate 规则;
alter database qiming default collate utf8_bin; 
-- 一般我们只需要了解校对规则的含义就行了，如果没有特殊的要求，一般就使用默认的校对规则，不需要刻意的去更改！





