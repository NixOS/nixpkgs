{ cabal, fclabels, hashable, hashtables }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.13.0.5";
  sha256 = "1vqkv3k0w1zy0111a786npf3hypbcg675lbdkv2cf3zx5hqcnn6j";
  buildDepends = [ fclabels hashable hashtables ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
