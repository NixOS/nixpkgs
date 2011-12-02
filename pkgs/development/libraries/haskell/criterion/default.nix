{ cabal, aeson, deepseq, hastache, mtl, mwcRandom, parsec
, statistics, time, transformers, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.6.0.0";
  sha256 = "0yi6gx9zrmljhhdfqpaylri8x71q2yzyhwwn1c377xngrskpydr9";
  buildDepends = [
    aeson deepseq hastache mtl mwcRandom parsec statistics time
    transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
