{ cabal, aeson, deepseq, filepath, hastache, mtl, mwcRandom, parsec
, statistics, time, transformers, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.6.2.1";
  sha256 = "08gbs61qqsq0kh2r33kzm9mmbs3ar5krmp1a0cf21c012k6k55z5";
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
