{ cabal }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.0.3";
  sha256 = "954f584f7c096c3ddef677e70b3811195bb4fd18dfdb4727a260ca7d7465de12";
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
