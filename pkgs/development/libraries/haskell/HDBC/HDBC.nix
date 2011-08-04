{cabal, HUnit, QuickCheck, mtl, time, utf8String, convertible, text, testpack}:

cabal.mkDerivation (self : {
  pname = "HDBC";
  version = "2.2.7.0";
  sha256 = "10bkmrd48knkr1zsm3fmnp7ah9y13pjwaya7z1f93sg29jq3k906";
  propagatedBuildInputs =
    [HUnit QuickCheck mtl time utf8String convertible text testpack];
  meta = {
    description = "HDBC provides an abstraction layer between Haskell programs and SQL relational databases";
  };
})
