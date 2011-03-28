{cabal, mtl, time}:

cabal.mkDerivation (self : {
  pname = "convertible";
  version = "1.0.9.1";
  sha256 = "a1f46bf1166356c02e7a241d0bfea7010dc3e5f9f15181cfc2405a95df402914";
  propagatedBuildInputs = [mtl time];
  meta = {
    description = "Typeclasses and instances for converting between types";
  };
})

