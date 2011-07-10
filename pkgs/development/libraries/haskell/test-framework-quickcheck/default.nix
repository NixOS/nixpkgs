{cabal, QuickCheck1, testFramework, deepseq}:

cabal.mkDerivation (self : {
  pname = "test-framework-quickcheck";
  version = "0.2.7";
  sha256 = "065nazli8vh9dz8xi71gwzlwy81anfd471jhz6hv3m893cc9vvx8";
  propagatedBuildInputs = [QuickCheck1 testFramework deepseq];
  meta = {
    description = "QuickCheck support for the test-framework package";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

