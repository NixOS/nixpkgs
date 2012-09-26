{ cabal, aeson, deepseq, filepath, hastache, mtl, mwcRandom, parsec
, statistics, time, transformers, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.6.1.1";
  sha256 = "1w5yqcgnx2ij3hmvmz5g4ynj6n8wa3yyk1kfbbwxyh9j5kc2xwiw";
  buildDepends = [
    aeson deepseq filepath hastache mtl mwcRandom parsec statistics
    time transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
