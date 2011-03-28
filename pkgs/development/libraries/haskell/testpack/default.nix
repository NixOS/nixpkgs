{cabal, HUnit, QuickCheck, mtl}:

cabal.mkDerivation (self : {
  pname = "testpack";
  version = "1.0.2";
  sha256 = "ff3d24a755aeeb765d5e93aa0189d0d67ac96b2d84e27a29609eb4738a6cdabc";
  propagatedBuildInputs = [HUnit QuickCheck mtl];
  meta = {
    description = "Test Utility Pack for HUnit and QuickCheck";
  };
})

