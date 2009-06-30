{cabal, HDBC, sqlite}:

cabal.mkDerivation (self : {
  pname = "HDBC-sqlite3";
  version = "2.1.0.0";
  sha256 = "a95f28fadd67ba1593cf75774308b7cfdde4a78ee5cba0a6aeb6c18723d8d67b";
  propagatedBuildInputs = [HDBC sqlite];
  meta = {
    description = "This is the Sqlite v3 driver for HDBC, the generic database access system for Haskell";
  };
})

