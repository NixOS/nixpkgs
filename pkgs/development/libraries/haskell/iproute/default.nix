{ cabal, appar, byteorder, doctest, hspec, network, QuickCheck
, safe
}:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.10";
  sha256 = "1ni91llvq1mfdsjmw1laqhk964y4vlpyk5s25j8klsfn27mq6c68";
  buildDepends = [ appar byteorder network ];
  testDepends = [
    appar byteorder doctest hspec network QuickCheck safe
  ];
  patchPhase = ''
    sed -i -e 's|Safe|safe|' iproute.cabal
  '';
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
