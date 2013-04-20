{ cabal, deepseq, extensibleExceptions, QuickCheck, random
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck";
  version = "0.3.0";
  sha256 = "0g8sh3x3mhns03svccgbdbw8crzpzmahp1hr1fs6ag66fqr8p9mv";
  buildDepends = [
    deepseq extensibleExceptions QuickCheck random testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
