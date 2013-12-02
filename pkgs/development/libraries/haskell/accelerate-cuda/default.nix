{ cabal, accelerate, binary, cryptohash, cuda, fclabels, filepath
, hashable, hashtables, languageCQuote, mainlandPretty, mtl
, SafeSemaphore, srcloc, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.14.0.0";
  sha256 = "1qms1w5rjjd77lldds2ljj9zr15dybnsaq8vxfyb5a4diq12bmi5";
  buildDepends = [
    accelerate binary cryptohash cuda fclabels filepath hashable
    hashtables languageCQuote mainlandPretty mtl SafeSemaphore srcloc
    text transformers unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-cuda/";
    description = "Accelerate backend for NVIDIA GPUs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
