{ cabal, extensibleExceptions, QuickCheck, random, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.2.12.2";
  sha256 = "08m8y78qy23imcwyqdqla7syxdf91iqrb0j8g6g7gwsg5asjq6ip";
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
