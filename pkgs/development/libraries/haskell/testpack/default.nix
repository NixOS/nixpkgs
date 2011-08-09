{ cabal, HUnit, QuickCheck, mtl }:

cabal.mkDerivation (self: {
  pname = "testpack";
  version = "2.1.0";
  sha256 = "8128f3a409855fca1d431391b2cbf6a9f4dec32dd6f26825960b936fe578c476";
  buildDepends = [ HUnit QuickCheck mtl ];
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
