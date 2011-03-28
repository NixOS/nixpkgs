{cabal, HUnit, QuickCheck}:

cabal.mkDerivation (self : {
  pname = "Crypto";
  version = "4.1.0";
  sha256 = "0984c833c5dfa6f4d56fd6fb284db7b7cef6676dc7999a1436aa856becba2b8f";
  propagatedBuildInputs = [HUnit QuickCheck];
  meta = {
    description = "Several encryption algorithms for Haskell";
  };
})

