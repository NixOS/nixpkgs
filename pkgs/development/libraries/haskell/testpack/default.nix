{cabal, HUnit, QuickCheck2, mtl}:

cabal.mkDerivation (self : {
  pname = "testpack";
  version = "2.1.0";
  sha256 = "8128f3a409855fca1d431391b2cbf6a9f4dec32dd6f26825960b936fe578c476";
  propagatedBuildInputs = [HUnit QuickCheck2 mtl];
  meta = {
    description = "Test Utility Pack for HUnit and QuickCheck";
  };
})

