CREATE DATABASE youngman CHARACTER SET utf8;
USE youngman;

/*
  建立用户表：
     变量名   变量类型  是否可空  变量描述
     uId      INT          否     用户唯一标识
     uName    VARCHAR      否     用户昵称
     uQQ      char         否     用户QQ号
     uAddress VARCHAR      是     用户地址
     uPhone   char         是     用户手机号
    * 补充：因为只有一次交易，所以不存在商品描述，但是可以对商家的信誉进行评分。
*/
CREATE TABLE users(
  uId INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  uName VARCHAR(16) NOT NULL,
  uQQ VARCHAR(10) NOT NULL,
  uAddress VARCHAR(50),
  uPhone VARCHAR(11) NOT NULL
);

/*
  建立商品表；
     变量名    变量类型  是否可空  变量描述
     gId       INT          否     商品唯一标识
     gImg      BLOB         否     商品参考图片
     gName     VARCHAR      否     商品名称
     gPrice    INT          否     商品价格
     gIntro    TEXT         是     商品描述
     isSaled   TINYINT      否     商品是否卖出
     gNum      INT          否     商品数量
     gCatalog  INT          否     商品所属分类
*/
CREATE TABLE goods(
  gId INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  gImg BLOB NOT NULL,
  gName VARCHAR(30) NOT NULL,
  gPrice INT NOT NULL,
  gIntro TEXT,
  isSaled TINYINT NOT NULL,
  gNum INT NOT NULL,
  gCatalog INT UNSIGNED NOT NULL REFERENCES catalog(cId)
);

/*
  建立商品分类目录
     变量名   变量类型  是否可空 变量描述
     cId      INT         否     分类id
     cName    VARCHAR     否     类别名称
*/
CREATE TABLE catalog(
  cId INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cName VARCHAR(30) NOT NULL
);

/*
  建立用户和商品的关系表 M-N 型
     变量名   变量类型  是否可空 变量描述
     rId      INT         否     序号，保持唯一性
     gOwner   INT         否     商品拥有者    
     uPossess INT         否     用户持有的商品  
*/
CREATE TABLE user_goods(
  ugId INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  gOwner INT UNSIGNED NOT NULL REFERENCES users(uId),
  uPossess INT UNSIGNED NOT NULL REFERENCES goods(gId)
);

/*
  添加外键约束
    一个用户可以收藏多个商品，同一个商品可以被多个用户购买（ gNum > 1 ) 。
    一个用户可以发布多个商品。
*/
ALTER TABLE user_goods 
ADD CONSTRAINT FK_gOwner 
FOREIGN KEY(gOwner) REFERENCES users(uId);

ALTER TABLE user_goods 
ADD CONSTRAINT FK_uPossess 
FOREIGN KEY(uPossess) REFERENCES goods(gId);

-- 添加用户数据
INSERT INTO users 
VALUES(NULL,'齐心','10001','北京东城','15622221111');
INSERT INTO users 
VALUES(NULL,'张三','10002','河北唐山','15322245212');
INSERT INTO users 
VALUES(NULL,'李四','10003','河南开封','15220155325');
INSERT INTO users 
VALUES(NULL,'王五','10004','山东德州','13800138000');

-- 添加商品数据
INSERT INTO goods 
VALUES(NULL,'image','保时捷',99,'这是商品描述',1,12,0);
INSERT INTO goods 
VALUES(NULL,'image','沐浴露',99,'这是商品描述',1,12,0);
INSERT INTO goods 
VALUES(NULL,'image','模电课本',99,'这是商品描述',1,12,0);
INSERT INTO goods 
VALUES(NULL,'image','卡西欧表',99,'这是商品描述',1,12,0);

-- 添加关系数据
INSERT INTO user_goods
VALUES(NULL,1,2);
INSERT INTO user_goods
VALUES(NULL,1,3);
INSERT INTO user_goods
VALUES(NULL,2,2);
INSERT INTO user_goods
VALUES(NULL,1,4);
INSERT INTO user_goods
VALUES(NULL,1,3);
INSERT INTO user_goods
VALUES(NULL,4,1);
INSERT INTO user_goods
VALUES(NULL,4,2);

-- 查询方法一：(内连接)
SELECT u.uName,g.gName
FROM users u,goods g,user_goods ug
WHERE ug.gOwner=u.uId AND ug.uPossess=g.gId;
-- 查询方法二：
SELECT u.uName,g.gName
FROM user_goods ug 
JOIN users u
  ON ug.gOwner=u.uId
JOIN goods g
  ON ug.uPossess=g.gId;
  
