{ cabal, deepseq, erf, HUnit, ieee754, mathFunctions, monadPar
, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.3.0";
  sha256 = "1ay03y9z84mc4ai6i4g81v129rhg4146kad4ggb2gimbj6851fw1";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
