{cabal, HUnit, QuickCheck}:

cabal.mkDerivation (self : {
  pname = "Ranged-sets";
  version = "0.2.1";
  sha256 = "dee83d2ea0ae56ff31eb7c74a0785328ca8621792c0859e223b12c17bb775f12";
  propagatedBuildInputs = [HUnit QuickCheck];
  meta = {
    description = "Ranged sets for Haskell";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

