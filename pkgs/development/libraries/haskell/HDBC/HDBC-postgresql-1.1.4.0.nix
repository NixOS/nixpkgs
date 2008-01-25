{cabal, HDBC, postgresql}:

cabal.mkDerivation (self : {
  pname = "HDBC-postgresql";
  version = "1.1.4.0";
  sha256 = "039eae03693330fee0e4083e22d502f94865969b243744a939786f598aec34ad";
  meta = {
    description = "This package provides a PostgreSQL driver for HDBC";
  };
  propagatedBuildInputs = [HDBC postgresql];
})

