{cabal, HDBC, sqlite, mtl, utf8String}:

cabal.mkDerivation (self : {
  pname = "HDBC-sqlite3";
  version = "2.3.1.0";
  sha256 = "0w90mnbl71hfwgscky25gy22w1arj9v3fyj8sy8cm7bkfbs70m8c";
  propagatedBuildInputs = [HDBC sqlite mtl utf8String];
  meta = {
    description = "This is the Sqlite v3 driver for HDBC, the generic database access system for Haskell";
  };
})

