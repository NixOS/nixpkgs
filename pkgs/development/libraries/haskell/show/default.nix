{ cabal, QuickCheck, random, simpleReflect, smallcheck, syb }:

cabal.mkDerivation (self: {
  pname = "show";
  version = "0.5";
  sha256 = "1s9nwhbc1935359r76glirg858c1sg8nfvv0bzzrncrgf0gxcl4f";
  buildDepends = [ QuickCheck random simpleReflect smallcheck syb ];
  meta = {
    description = "'Show' instances for Lambdabot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
