{ cabal, HUnit, mtl, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "testpack";
  version = "2.1.2.1";
  sha256 = "1fm4dy9vs2whc48cr00ncqqzz6r5yp7bvgil86idbbgi8igld5j0";
  buildDepends = [ HUnit mtl QuickCheck random ];
  patches = [ ./support-recent-quickcheck.patch ];
  jailbreak = true;
  meta = {
    homepage = "http://hackage.haskell.org/cgi-bin/hackage-scripts/package/testpack";
    description = "Test Utililty Pack for HUnit and QuickCheck";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
