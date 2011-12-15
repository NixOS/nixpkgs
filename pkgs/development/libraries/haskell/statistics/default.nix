{ cabal, deepseq, erf, monadPar, mwcRandom, primitive, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.10.0.1";
  sha256 = "0bn131yzq3qk4dpr78i3ndsxyn7hars9jw9krfsxmin9pqr114sw";
  buildDepends = [
    deepseq erf monadPar mwcRandom primitive vector vectorAlgorithms
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
