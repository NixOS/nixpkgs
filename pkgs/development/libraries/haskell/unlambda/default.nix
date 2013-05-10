{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "unlambda";
  version = "0.1.3";
  sha256 = "0clcpkhg23a7ma72rjjpl2w8jpg2mdn4rgm3vf0vqr7lbyma1h89";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  meta = {
    description = "Unlambda interpreter";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
