{ cabal, deepseq, erf, mathFunctions, monadPar, mwcRandom
, primitive, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.1.0";
  sha256 = "0fnpwnhcwxjcm81b9daqdy07cw5qgqa7m2bj6fxxwicpvawcyabc";
  buildDepends = [
    deepseq erf mathFunctions monadPar mwcRandom primitive vector
    vectorAlgorithms
  ];
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
