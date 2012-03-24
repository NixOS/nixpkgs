{ cabal }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.2.1";
  sha256 = "47235503b666658588181795540d29212283059b21edc42e1b4f1998e46ac853";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
