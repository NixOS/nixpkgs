{ cabal, binary, deepseq, erf, HUnit, ieee754, mathFunctions
, monadPar, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.11.0.0";
  sha256 = "1pmkdy7v78ajl5b5rjshgabhcakb9ji5wlq79ajr1b5adif1d1d9";
  buildDepends = [
    binary deepseq erf mathFunctions monadPar mwcRandom primitive
    vector vectorAlgorithms vectorBinaryInstances
  ];
  testDepends = [
    binary erf HUnit ieee754 mathFunctions mwcRandom primitive
    QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector vectorAlgorithms
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/statistics";
    description = "A library of statistical types, data, and functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
