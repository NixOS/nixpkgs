{cabal, QuickCheck2, testFramework}:

cabal.mkDerivation (self : {
  pname = "test-framework-quickcheck2";
  version = "0.2.10";
  sha256 = "12c37m74idjydxshgms9ib9ii2rpvy4647kra2ards1w2jmnr6w3";
  propagatedBuildInputs = [QuickCheck2 testFramework];
  meta = {
    description = "QuickCheck2 support for the test-framework package";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

