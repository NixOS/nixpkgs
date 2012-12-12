{ cabal, appar, byteorder, network }:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.9";
  sha256 = "0r0g8dd0f5n462kil3m2lhycl84ygd0ayh900h9x8phgwzfxzv8i";
  buildDepends = [ appar byteorder network ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
