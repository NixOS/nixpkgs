{ cabal, Cabal, deepseq, extensibleExceptions, QuickCheck, random
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck";
  version = "0.2.8";
  sha256 = "0ca6s7dnrdr9s2gdpfb74lswlj2lj091crk89m3yqjcadchkh3vl";
  buildDepends = [
    Cabal deepseq extensibleExceptions QuickCheck random testFramework
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
