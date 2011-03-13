{cabal, primitive, vector, vectorAlgorithms, mwcRandom, erf}:

cabal.mkDerivation (self : {
  pname = "statistics";
  version = "0.8.0.5";
  sha256 = "0rzrx1wjil88ksqk5kmcxm4ypryiy9j1c4qa2s2bs71338hhzpxn";
  propagatedBuildInputs =
    [primitive vector vectorAlgorithms mwcRandom erf];
  meta = {
    description = "A library of statistical types, data and functions";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

