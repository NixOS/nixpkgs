{ cabal, enumerator, pcap, transformers }:

cabal.mkDerivation (self: {
  pname = "pcap-enumerator";
  version = "0.4";
  sha256 = "0ka2n7740s02marvd1b11mrxc663kj0zcn7hksl5i13ls026hpb8";
  buildDepends = [ enumerator pcap transformers ];
  meta = {
    homepage = "http://github.com/cutsea110/pcap-enumerator";
    description = "Convert a pcap into an enumerator";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
