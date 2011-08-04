{cabal, HDBC, postgresql, parsec}:

cabal.mkDerivation (self : {
  pname = "HDBC-postgresql";
  version = "2.2.3.3";
  sha256 = "1wh3pwqgxilz4v108q88z1gcqyzxp1fzd47s6g4857m1fzbdj7an";
  propagatedBuildInputs = [HDBC parsec postgresql];
  meta = {
    description = "This package provides a PostgreSQL driver for HDBC";
  };
})

