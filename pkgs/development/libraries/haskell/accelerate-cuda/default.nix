{ cabal, accelerate, binary, blazeBuilder, cryptohash, cuda
, fclabels, filepath, hashable, hashtables, languageCQuote
, mainlandPretty, mtl, srcloc, symbol, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.12.0.0";
  sha256 = "1h8rx8jcv3x7hg8fr23fzy59lcv72rb914vyczs40bgfr4cgdaaa";
  buildDepends = [
    accelerate binary blazeBuilder cryptohash cuda fclabels filepath
    hashable hashtables languageCQuote mainlandPretty mtl srcloc symbol
    transformers unorderedContainers
  ];
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Accelerate backend for NVIDIA GPUs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
