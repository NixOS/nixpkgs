{ cabal, deepseq, erf, HUnit, ieee754, mathFunctions, monadPar
, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.3.1";
  sha256 = "12abfqxsriqlncr60wwcsm0q41hmqc6vp9p1hmnv2l3qqcisk60s";
  buildDepends = [
    deepseq erf mathFunctions monadPar mwcRandom primitive vector
    vectorAlgorithms
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
