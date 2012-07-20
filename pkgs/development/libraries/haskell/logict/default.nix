{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "logict";
  version = "0.5.0.1";
  sha256 = "0k3acw6fwhqz4qaz7k85fx5b43hwc926il0mljc69gjrgw0c8nzv";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/logict";
    description = "A backtracking logic-programming monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
