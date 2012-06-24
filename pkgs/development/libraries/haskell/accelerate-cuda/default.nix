{ cabal, accelerate, binary, blazeBuilder, cryptohash, cuda
, fclabels, filepath, hashable, hashtables, languageCQuote
, mainlandPretty, mtl, srcloc, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.12.1.0";
  sha256 = "1y6viivizv4frdh3xk5wqhs7wwnhqyjr9wid1y1d5l42mz41vp84";
  buildDepends = [
    accelerate binary blazeBuilder cryptohash cuda fclabels filepath
    hashable hashtables languageCQuote mainlandPretty mtl srcloc
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
