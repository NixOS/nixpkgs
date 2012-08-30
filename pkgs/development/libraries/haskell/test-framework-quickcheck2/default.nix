{ cabal, extensibleExceptions, QuickCheck, random, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.2.12.3";
  sha256 = "17pj6b1cclihy203zpb75rkx2djldc9kcj10wqkf5fjmf9vvi0ks";
  buildDepends = [
    extensibleExceptions QuickCheck random testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
