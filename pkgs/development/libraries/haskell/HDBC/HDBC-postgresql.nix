{ cabal, Cabal, HDBC, mtl, parsec, postgresql, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC-postgresql";
  version = "2.3.2.0";
  sha256 = "0fwza9h2ghl70x44c4snfybnnfsj1mwlf5a1x12ddl1fbj6fx6gs";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal HDBC mtl parsec time utf8String ];
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://software.complete.org/hdbc-postgresql";
    description = "PostgreSQL driver for HDBC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
