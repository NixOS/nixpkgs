{ cabal, convertible, HDBC, mtl, parsec, postgresql, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HDBC-postgresql";
  version = "2.3.2.2";
  sha256 = "0x42lf429dxjkz22jn5fybimlixxs20zq01ap40344qlwh01hd90";
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
