-- --------------------------------------------------------------------------------
-- Music Record Database

-- Mission Statement: A database to store all customers, customer orders and order 
-- history, products, and vendors. Be able to create list of best-selling products 
-- and most utilized product vendor based on customers' shopping history.
-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbMusicRecord;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors
-- --------------------------------------------------------------------------------
-- Logical Order of Drop Tables
-- --------------------------------------------------------------------------------
-- 1 TOrderProducts - Table is child of TOrders & TProducts
-- 2 TOrders - Table is a child of TCustomers
-- 3 TCustomers
-- 4 TProducts - Table is child of TVendors
-- 5 TVendors

IF OBJECT_ID ('TOrderProducts') IS NOT NULL DROP TABLE TOrderProducts
IF OBJECT_ID ('TOrders')		IS NOT NULL DROP TABLE TOrders
IF OBJECT_ID ('TCustomers')		IS NOT NULL DROP TABLE TCustomers
IF OBJECT_ID ('TProducts')		IS NOT NULL DROP TABLE TProducts
IF OBJECT_ID ('TVendors')		IS NOT NULL DROP TABLE TVendors
-- --------------------------------------------------------------------------------
--  Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TVendors
(
	intVendorID				INTEGER			NOT NULL
   ,strVendorName			VARCHAR(50)		NOT NULL
   ,strAddress				VARCHAR(50)		NOT NULL
   ,strCity					VARCHAR(50)		NOT NULL
   ,strState				VARCHAR(50)		NOT NULL
   ,strZip					VARCHAR(50)		NOT NULL
   ,strContactFirstName		VARCHAR(50)		NOT NULL
   ,strContactLastName		VARCHAR(50)		NOT NULL
   ,strPhoneNumber			VARCHAR(255)	NOT NULL
   ,strEmailAddress			VARCHAR(255)	NOT NULL
   ,Constraint TVendors_PK	PRIMARY KEY ( intVendorID )
)

CREATE TABLE TProducts
(
	 intProductID			INTEGER			NOT NULL
	,intVendorID			INTEGER			NOT NULL
	,strProductName			VARCHAR(255)	NOT NULL
	,strProductCategory		VARCHAR(50)		NOT NULL
	,monProductCost			MONEY			NOT NULL
	,monRetailPrice			MONEY			NOT NULL
	,intInventoryTotal		INTEGER			NOT NULL
	,CONSTRAINT TProducts_PK	PRIMARY KEY ( intProductID )
)

CREATE TABLE TCustomers
(
	 intCustomerID			INTEGER			NOT NULL
	,strFirstName			VARCHAR(50)		NOT NULL
	,strLastName			VARCHAR(50)		NOT NULL
	,strAddress				VARCHAR(50)		NOT NULL
	,strCity				VARCHAR(50)		NOT NULL
	,strState				VARCHAR(50)		NOT NULL
	,strZip					VARCHAR(50)		NOT NULL
	,strGender				VARCHAR(50)		NOT NULL
	,strRace				VARCHAR(50)		NOT NULL
	,dtmDateOfBirth			DATE			NOT NULL
	,CONSTRAINT TCustomers_PK	PRIMARY KEY ( intCustomerID )
)

CREATE TABLE TOrders
(
	 intOrderID			INTEGER			NOT NULL
	,intCustomerID		INTEGER			NOT NULL
	,strOrderNumber		VARCHAR(255)	NOT NULL
	,strStatus			VARCHAR(50)		NOT NULL
	,dtmDateOrdered		DATETIME		NOT NULL
	,CONSTRAINT TOrders_PK	PRIMARY KEY ( intOrderID )
)

CREATE TABLE TOrderProducts
(
	intOrderProductID			INTEGER			NOT NULL
   ,intOrderID					INTEGER			NOT NULL
   ,intProductID				INTEGER			NOT NULL
   ,CONSTRAINT TOrderProducts_PK	PRIMARY KEY ( intOrderProductID )
)
-- --------------------------------------------------------------------------------
--	Establish referential integrity
-- --------------------------------------------------------------------------------
-- #	Child					Parent					Column
-- -	------					------					------
-- 1	TProduct				TVendor				intVendorID
-- 2	TOrderProducts			TOrders				intOrderID
-- 3	TOrderProducts			TProduct			intProductID
-- 4	TOrders					TCustomers			intCustomerID

-- 1
ALTER TABLE TProducts ADD CONSTRAINT TProducts_TVendors_FK 
FOREIGN KEY ( intVendorID ) REFERENCES TVendors ( intVendorID )

-- 2 
ALTER TABLE TOrderProducts ADD CONSTRAINT TOrderProducts_TOrders_FK 
FOREIGN KEY ( intOrderID ) REFERENCES TOrders ( intOrderID )

-- 3
ALTER TABLE TOrderProducts ADD CONSTRAINT TOrderProducts_TProducts_FK 
FOREIGN KEY ( intProductID ) REFERENCES TProducts ( intProductID )

-- 4
ALTER TABLE TOrders ADD CONSTRAINT TOrders_TCustomers_FK
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID )

-- --------------------------------------------------------------------------------
--	INSERT INTO...VALUES
-- --------------------------------------------------------------------------------
INSERT INTO TVendors( intVendorID, strVendorName, strAddress, strCity, strState, strZip, strContactFirstName, strContactLastName, strPhoneNumber, strEmailAddress )
VALUES				 ( 1, 'Student Stencilers Society','4569 Left Avenue', 'Cincinnati', 'OH', '45223', 'Sam', 'Smithy', '513-956-3579', 'sammity@sol.com' )
					,( 2, 'It is A Garden!','123 Park Place', 'Cincinnati', 'OH', '45219', 'Lavender', 'Marigold', '513-316-6495', 'flower_child@sunshine.edu' )
					,( 3, 'Open Box Builders Outlet','1800 Strongs Street', 'Cincinnati', 'OH', '45224', 'Bucky', 'Buildsometimes', '513-513-5113', 'bucky1@builders.com' )

INSERT INTO TProducts ( intProductID, intVendorID, strProductName, strProductCategory, monProductCost, monRetailPrice, intInventoryTotal )
VALUES				 ( 1, 1, 'The Big Book of Self-Help for Student Stencilers: A Trilogy', 'Books', 2.50, 15, 1500 )
					,( 2, 3, 'Blue Bucket', 'Home Improvement', 0.50, 3, 888 )
					,( 3, 2, 'Garlic-Free Stakes for Inclusive Gardeners', 'Garden & Lawn', 6, 7, 3 )

INSERT INTO TCustomers ( intCustomerID, strFirstName, strLastName, strAddress, strCity, strState, strZip, strGender, strRace, dtmDateOfBirth )
VALUES				( 1, 'Bob', 'Nields', '4563 RR8', 'Covington', 'KY', '44034', 'Male', 'White', '6/6/1987' )
				   ,( 2, 'Raye', 'Harmon', '12 Nuance Way', 'New York City', 'OH', '45040', 'Female', 'Black', '8/11/1995' )
				   ,( 3, 'Kim', 'Smith', '1694 Washington Ave.', 'Florence', 'KY', '44122', 'Non-binary', 'Asian', '1/3/2004' )

INSERT INTO TOrders ( intOrderID, intCustomerID, strOrderNumber, strStatus, dtmDateOrdered )
VALUES				  ( 1, 1, 'AO1597354949156', 'In Process', '2024-06-03 23:59:59' )
					 ,( 2, 3, 'AO5648971254157', 'Shipped', '2024-02-15 08:35:02' )
					 ,( 3, 2, 'AO1564641545641', 'Delivered', '2024-12-19 06:14:16' )

INSERT INTO TOrderProducts ( intOrderProductID, intOrderID, intProductID )
VALUES				( 1, 1, 2 )
				   ,( 2, 2, 1 )
				   ,( 3, 3, 2 )
				   ,( 4, 3, 3 )
				   ,( 5, 2, 3 )
-- --------------------------------------------------------------------------------
--	SELECT Join to return all rows & columns of all customers, their info, 
--	their orders, and info on their order(s)
-- --------------------------------------------------------------------------------
SELECT 
	TCustomers.strFirstName, TCustomers.strLastName, TCustomers.strAddress, TCustomers.strCity, TCustomers.strState, TCustomers.strZip, TCustomers.strGender, TCustomers.strRace, TCustomers.dtmDateOfBirth
   ,TOrders.strOrderNumber, TOrders.dtmDateOrdered
FROM
	TCustomers
   ,TOrders
   ,TOrderProducts
   
WHERE TCustomers.intCustomerID = TOrders.intCustomerID
	AND TOrderProducts.intOrderID = TOrders.intOrderID
-- --------------------------------------------------------------------------------
--	SELECT Join to return all rows & columns of a particular customer, 
--	their info, their order(s), and info on their order(s)
-- --------------------------------------------------------------------------------
SELECT 
	TCustomers.strFirstName, TCustomers.strLastName, TCustomers.strAddress, TCustomers.strCity, TCustomers.strState, TCustomers.strZip, TCustomers.strGender, TCustomers.strRace, TCustomers.dtmDateOfBirth
   ,TOrders.strOrderNumber, TOrders.dtmDateOrdered
FROM
	TCustomers
   ,TOrders
   ,TOrderProducts
WHERE TCustomers.strLastName = 'Smith'
	AND TCustomers.intCustomerID = TOrders.intCustomerID
	AND TOrderProducts.intOrderID = TOrders.intOrderID
-- --------------------------------------------------------------------------------
--	SELECT Join to return all rows & columns of a particular customer
--	based on last name, their info, their order(s), and info on their 
--	order(s) including products  
-- --------------------------------------------------------------------------------
SELECT 
	TCustomers.strFirstName, TCustomers.strLastName, TCustomers.strAddress, TCustomers.strCity, TCustomers.strState, TCustomers.strZip, TCustomers.strGender, TCustomers.strRace, TCustomers.dtmDateOfBirth
   ,TOrders.strOrderNumber, TOrders.dtmDateOrdered
   ,TProducts.strProductName
FROM
	TCustomers
   ,TOrders
   ,TOrderProducts
   ,TProducts
WHERE TCustomers.strLastName = 'Smith'
	AND TCustomers.intCustomerID = TOrders.intCustomerID
	AND TOrderProducts.intOrderID = TOrders.intOrderID
	AND TOrderProducts.intProductID = TProducts.intProductID
-- --------------------------------------------------------------------------------
--	SELECT Join to return all rows & columns of all vendors, 
--	their info, the products they supply, and info on their products
-- --------------------------------------------------------------------------------
SELECT 
	TVendors.strVendorName, TVendors.strAddress, TVendors.strCity, TVendors.strState, TVendors.strZip
   ,TVendors.strContactFirstName, TVendors.strContactLastName, TVendors.strPhoneNumber, TVendors.strEmailAddress
   ,TProducts.strProductName, TProducts.strProductCategory, TProducts.monProductCost, TProducts.monRetailPrice, TProducts.intInventoryTotal
FROM
	TVendors
   ,TProducts
WHERE TProducts.intVendorID = TVendors.intVendorID
-- ---------------------------------------------------------------------------------
--	SELECT Join to return all rows & columns of a particular vendor 
--	based on last name, their info, the products they supply, and 
--	info on their products
-- ---------------------------------------------------------------------------------
SELECT 
	TVendors.strVendorName, TVendors.strAddress, TVendors.strCity, TVendors.strState, TVendors.strZip
   ,TVendors.strContactFirstName, TVendors.strContactLastName, TVendors.strPhoneNumber, TVendors.strEmailAddress
   ,TProducts.strProductName, TProducts.strProductCategory, TProducts.monProductCost, TProducts.monRetailPrice, TProducts.intInventoryTotal
FROM
	TVendors
   ,TProducts
WHERE TVendors.strContactLastName = 'Smithy'
	AND TProducts.intVendorID = TVendors.intVendorID


