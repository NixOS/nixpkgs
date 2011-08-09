{ cabal, aeson, deepseq, erf, monadPar, mwcRandom, primitive, time
, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.9.0.0";
  sha256 = "1rwp9gkjs011lxzhkajiljs6x2a4xc8cg558kpfy9xj4q1lk43x7";
  buildDepends = [
    aeson deepseq erf monadPar mwcRandom primitive time vector
    vectorAlgorithms
  ];
  meta = {
    homepage = "http://bitbucket.org/bos/statistics";
    description = "A library of statistical types, data, and functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
