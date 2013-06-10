{ cabal, accelerate, binary, cryptohash, cuda, fclabels, filepath
, hashable, hashtables, languageCQuote, mainlandPretty, mtl
, SafeSemaphore, srcloc, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.13.0.2";
  sha256 = "1i8p6smj82k9nw0kz17247nzby8k8x0il8d2d3rbps5j03795dfk";
  buildDepends = [
    accelerate binary cryptohash cuda fclabels filepath hashable
    hashtables languageCQuote mainlandPretty mtl SafeSemaphore srcloc
    text transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-cuda/";
    description = "Accelerate backend for NVIDIA GPUs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
