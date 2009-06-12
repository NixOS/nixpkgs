{cabal, HUnit, QuickCheck, mtl, time, utf8String, convertible, testpack}:

cabal.mkDerivation (self : {
  pname = "HDBC";
  version = "2.1.1";
  sha256 = "9a3ab307c006fb9c22089a15d190339c45de0a32e700f2d9eda70423e719197c";
  propagatedBuildInputs =
    [HUnit QuickCheck mtl time utf8String convertible testpack];
  meta = {
    description = "HDBC provides an abstraction layer between Haskell programs and SQL relational databases";
  };
})
