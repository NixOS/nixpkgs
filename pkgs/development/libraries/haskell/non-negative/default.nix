{cabal, QuickCheck, utilityHt}:

cabal.mkDerivation (self : {
  pname = "non-negative";
  version = "0.1";
  sha256 = "0aebb6f5518191a02b11230798444997a03b84d63d2aaa6c38cac6718f6c351c";
  propagatedBuildInputs = [QuickCheck utilityHt];
  meta = {
    description = "Non-negative numbers";
  };
})

