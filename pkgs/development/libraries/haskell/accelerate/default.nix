{ cabal, fclabels, hashable, hashtables }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.13.0.1";
  sha256 = "01vkvvvzlj023cwxz90clrcgz4xyz0nb8idm1zad21gzrij14915";
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
