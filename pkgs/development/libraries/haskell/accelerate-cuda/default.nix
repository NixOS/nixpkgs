{ cabal, accelerate, binary, cryptohash, cuda, fclabels, filepath
, hashable, hashtables, languageCQuote, mainlandPretty, mtl
, SafeSemaphore, srcloc, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.13.0.4";
  sha256 = "0zdb02mj9sbkj51a1q7sl6kmjx51gvps52dwc70qpm3rk71qnp1k";
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
    hydraPlatforms = [];
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
