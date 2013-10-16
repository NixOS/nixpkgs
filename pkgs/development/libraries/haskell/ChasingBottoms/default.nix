{ cabal, mtl, QuickCheck, random, syb }:

cabal.mkDerivation (self: {
  pname = "ChasingBottoms";
  version = "1.3.0.7";
  sha256 = "0g1bx6d2mi27qsb4bxvby50g39fm56gyi2658fyjiq1gamy50ypa";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl QuickCheck random syb ];
  meta = {
    description = "For testing partial and infinite values";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
