{ cabal, convertible, mtl, text, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC";
  version = "2.3.1.1";
  sha256 = "1gqihvsf5w7j8xbn1xy93mdrsh77qwxbhfmyjivbm6i95w1i0kb7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ convertible mtl text time utf8String ];
  meta = {
    homepage = "https://github.com/hdbc/hdbc";
    description = "Haskell Database Connectivity";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
