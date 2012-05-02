{ cabal, deepseq, extensibleExceptions, QuickCheck, random
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck";
  version = "0.2.8.1";
  sha256 = "042vdq18mqw4rhsj3x51mz1iv9zbxvlz7jg6r9cni2xpw5m7v6dk";
  buildDepends = [
    deepseq extensibleExceptions QuickCheck random testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
