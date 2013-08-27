{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "network-multicast";
  version = "0.0.8";
  sha256 = "0jsbp8z2a69x5h6dc3b16wdxs0shv6438mnf5mg0jxq7xddbhph8";
  buildDepends = [ network ];
  meta = {
    description = "Simple multicast library";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
