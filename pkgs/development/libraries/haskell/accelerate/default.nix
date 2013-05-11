{ cabal, fclabels, hashable, hashtables }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.13.0.0";
  sha256 = "07ph5brvxwi8k5calqmgiyafll2w88679rnpcv6bk5z57bsb5jli";
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
