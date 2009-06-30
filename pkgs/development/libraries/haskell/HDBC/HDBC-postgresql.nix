{cabal, HDBC, postgresql, parsec}:

cabal.mkDerivation (self : {
  pname = "HDBC-postgresql";
  version = "2.1.0.0";
  sha256 = "424b491766410df73f2df87a5cd4b5f4549850cc53a2f1c937b546ff1ef1562b";
  propagatedBuildInputs = [HDBC parsec postgresql];
  meta = {
    description = "This package provides a PostgreSQL driver for HDBC";
  };
})

