{ cabal, HUnit, QuickCheck, mtl, random }:

cabal.mkDerivation (self: {
  pname = "testpack";
  version = "2.1.1";
  sha256 = "1z8g3xhvy901h7kr7q4wcms5b23xniskrgxfpq42w4b34acwvhmg";
  buildDepends = [ HUnit QuickCheck mtl random ];
  meta = {
    homepage = "http://hackage.haskell.org/cgi-bin/hackage-scripts/package/testpack";
    description = "Test Utililty Pack for HUnit and QuickCheck";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
