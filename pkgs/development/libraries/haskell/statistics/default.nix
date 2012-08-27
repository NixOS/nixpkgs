{ cabal, deepseq, erf, mathFunctions, monadPar, mwcRandom
, primitive, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.2.0";
  sha256 = "1sv0fhbi52maq9c4ni109m0051a1nndi3ncz9v29mkxqzyckrp9x";
  buildDepends = [
    deepseq erf mathFunctions monadPar mwcRandom primitive vector
    vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/statistics";
    description = "A library of statistical types, data, and functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
