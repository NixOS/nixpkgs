{ cabal, accelerate, binary, cryptohash, cuda, fclabels, filepath
, hashable, hashtables, languageCQuote, mainlandPretty, mtl, srcloc
, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.12.1.2";
  sha256 = "184rxdp9idvhrqa0k3fqcm3nrgjcs3f53dz7wrhhpfa3iqrr6vd4";
  buildDepends = [
    accelerate binary cryptohash cuda fclabels filepath hashable
    hashtables languageCQuote mainlandPretty mtl srcloc text
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
