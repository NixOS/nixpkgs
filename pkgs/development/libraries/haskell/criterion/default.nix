{ cabal, aeson, deepseq, mtl, mwcRandom, parsec, statistics, time
, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.5.1.1";
  sha256 = "0gxl6xym01lvblkdsqigx4p13nc9y7hcvyrqz0kvnvcf2f9x4qvp";
  buildDepends = [
    aeson deepseq mtl mwcRandom parsec statistics time vector
    vectorAlgorithms
  ];
  meta = {
    homepage = "http://bitbucket.org/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
