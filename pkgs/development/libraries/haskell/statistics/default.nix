{ cabal, binary, deepseq, erf, HUnit, ieee754, mathFunctions
, monadPar, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.11.0.1";
  sha256 = "17p4dj7wimnl5fcwxpmcmgcmwpypfkk3gzmgmx9qvxl8p38lwacc";
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
