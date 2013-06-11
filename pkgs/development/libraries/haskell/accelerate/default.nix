{ cabal, fclabels, hashable, hashtables }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.13.0.4";
  sha256 = "1rhbvzgafw3cx2wi4zfil4nxcziqpbh20q3nafck30q2xvrwkmwm";
  buildDepends = [ fclabels hashable hashtables ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
