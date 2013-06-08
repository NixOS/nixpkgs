{ cabal, fclabels, hashable, hashtables }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.13.0.2";
  sha256 = "1xcgcr3wrvvckjhxbr80567gmg6rx9ks7rl4jcr6c6mdv6svx4jb";
  buildDepends = [ fclabels hashable hashtables ];
  noHaddock = true;
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
