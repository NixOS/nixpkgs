{cabal, primitive, vector, vectorAlgorithms, mwcRandom, erf}:

cabal.mkDerivation (self : {
  pname = "statistics";
  version = "0.8.0.3";
  sha256 = "11b7ai661sm7j4n8wymipzjldshackwgv6kkp6yqrkxzg40xhal9";
  propagatedBuildInputs =
    [primitive vector vectorAlgorithms mwcRandom erf];
  meta = {
    description = "A library of statistical types, data and functions";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

