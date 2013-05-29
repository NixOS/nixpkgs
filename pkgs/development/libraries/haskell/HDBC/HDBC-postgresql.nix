{ cabal, convertible, HDBC, mtl, parsec, postgresql, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HDBC-postgresql";
  version = "2.3.2.1";
  sha256 = "1ji10w4d91dp3ci7pn1jd8nb3wasszwlsy1lfbb4mqnr15c9vnpb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ convertible HDBC mtl parsec time utf8String ];
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://github.com/hdbc/hdbc-postgresql";
    description = "PostgreSQL driver for HDBC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
