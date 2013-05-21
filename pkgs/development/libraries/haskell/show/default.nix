{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "show";
  version = "0.6";
  sha256 = "15bvfffnr034z8wbmhxa8h5qskbxwbflk434dx023l1qlm3sjmsg";
  buildDepends = [ syb ];
  meta = {
    description = "'Show' instances for Lambdabot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
