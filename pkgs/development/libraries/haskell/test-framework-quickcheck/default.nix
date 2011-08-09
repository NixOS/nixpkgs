{ cabal, QuickCheck, deepseq, extensibleExceptions, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck";
  version = "0.2.7";
  sha256 = "065nazli8vh9dz8xi71gwzlwy81anfd471jhz6hv3m893cc9vvx8";
  buildDepends = [
    QuickCheck deepseq extensibleExceptions testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck support for the test-framework package.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
