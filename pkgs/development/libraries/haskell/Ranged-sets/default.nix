{ cabal, Cabal, HUnit, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "Ranged-sets";
  version = "0.3.0";
  sha256 = "1am0lsd3yiyn7ayk9k4ff7zdj67m0pxjl10cxi5f9hgjj4y9380l";
  buildDepends = [ Cabal HUnit QuickCheck ];
  meta = {
    homepage = "http://code.haskell.org/ranged-sets";
    description = "Ranged sets for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
