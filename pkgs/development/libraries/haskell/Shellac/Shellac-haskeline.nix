{cabal, Shellac, haskeline}:

cabal.mkDerivation (self : {
  pname = "Shellac-haskeline";
  version = "0.2";
  sha256 = "e3024b1915efd9841be9f405503f26c52524e7ea2a9c630ad651a9986e5329e0";
  propagatedBuildInputs = [Shellac haskeline];
  meta = {
    description = "Haskeline backend module for Shellac";
  };
})

