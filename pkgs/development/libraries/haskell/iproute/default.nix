{ cabal, appar, byteorder, network }:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.7";
  sha256 = "07ixxq45w5wzvfrvsv2b206kygiqn1v3bcclkd98afjpc6mv3ld3";
  buildDepends = [ appar byteorder network ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
