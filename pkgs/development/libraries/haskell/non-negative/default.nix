{cabal, QuickCheck}:

cabal.mkDerivation (self : {
  pname = "non-negative";
  version = "0.0.4";
  sha256 = "0b82b7be086c8d4e493d606098d82c2e5d943fe76d18a5eb6836c449ba19fc6f";
  propagatedBuildInputs = [QuickCheck];
  meta = {
    description = "Non-negative numbers";
  };
})

