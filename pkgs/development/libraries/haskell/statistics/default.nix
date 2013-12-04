{ cabal, binary, deepseq, erf, HUnit, ieee754, mathFunctions
, monadPar, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.5.1";
  sha256 = "1ld7cf83asia8dbq7kbn2s6f7la01scafk2wra2c85pmkql77kvc";
  buildDepends = [
    binary deepseq erf mathFunctions monadPar mwcRandom primitive
    vector vectorAlgorithms vectorBinaryInstances
  ];
  testDepends = [
    erf HUnit ieee754 mathFunctions mwcRandom primitive QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2 vector
    vectorAlgorithms
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
