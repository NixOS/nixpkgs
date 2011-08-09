{ cabal, haskeline, mtl }:

cabal.mkDerivation (self: {
  pname = "haskeline-class";
  version = "0.6.1";
  sha256 = "da954acea7ae215865a647fff776df9621ee5c5133a5f95c16b1ac5646ef0b31";
  buildDepends = [ haskeline mtl ];
  meta = {
    homepage = "http://community.haskell.org/~aslatter/code/haskeline-class";
    description = "Class interface for working with Haskeline";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
