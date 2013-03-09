{ cabal, appar, byteorder, doctest, hspec, network, QuickCheck
, safe
}:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.11";
  sha256 = "14f96sb41f5m14186900rz84vwv7idjiylp8m5nsm6gganvh4sh4";
  buildDepends = [ appar byteorder network ];
  testDepends = [
    appar byteorder doctest hspec network QuickCheck safe
  ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
