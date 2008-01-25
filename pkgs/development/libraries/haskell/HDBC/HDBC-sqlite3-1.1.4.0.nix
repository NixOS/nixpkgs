{cabal, HDBC, sqlite}:

cabal.mkDerivation (self : {
  pname = "HDBC-sqlite3";
  version = "1.1.4.0";
  sha256 = "328fed8d4cdba4311efd50d9d60591a81481317ddba10c58fbaa2ec7f418f788";
  meta = {
    description = "This is the Sqlite v3 driver for HDBC, the generic database access system for Haskell";
  };
  propagatedBuildInputs = [HDBC sqlite];
})

