{ cabal, accelerate, binary, cryptohash, cuda, fclabels, filepath
, hashable, hashtables, languageCQuote, mainlandPretty, mtl
, SafeSemaphore, srcloc, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.13.0.0";
  sha256 = "1wlvnbafdbjs8s1ds1zip2wqag96y1nj03zhr0sikgccyszfadf1";
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
