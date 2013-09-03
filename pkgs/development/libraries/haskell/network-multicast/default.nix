{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "network-multicast";
  version = "0.0.10";
  sha256 = "092v4ba6mrl5ykx2fscclcsc5dbnq99hbn93sc2mjnnr8c9r0n5x";
  buildDepends = [ network ];
  meta = {
    description = "Simple multicast library";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
