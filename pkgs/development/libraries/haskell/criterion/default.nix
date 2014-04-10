{ cabal, aeson, binary, deepseq, filepath, Glob, hastache, mtl
, mwcRandom, parsec, statistics, text, time, transformers, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.8.0.2";
  sha256 = "126c3i9i88wqs5ihif4kpsc1gdqas57acd8h5jbyfqhgbwi1s7gz";
  buildDepends = [
    aeson binary deepseq filepath Glob hastache mtl mwcRandom parsec
    statistics text time transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
