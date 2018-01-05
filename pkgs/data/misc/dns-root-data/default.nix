{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    # Original source https://www.internic.net/domain/named.root
    # occasionally suffers from pointless hash changes,
    # and having stable sources for older versions has advantages, too.
    urls = [
      "https://gist.githubusercontent.com/veprbl/145bfd5db525d63ac4ad506af2c3ac90/raw/af0e4acaa1d3d93b1e8d60f8f9865b5449cac766/named.root"
      "https://gateway.ipfs.io/ipfs/QmVPqoxuwHZ4J7ddpT8TV648JCyZ8Kx8tk7u5vm7YCqRPi/named.root"
      ];
    sha256 = "01n4bqf95kbvig1hahqzmmdkpn4v7mzfc1p944gq922i5j3fjr92";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  name = "dns-root-data-2017-08-29";

  buildCommand = ''
    mkdir $out
    cp ${rootHints} $out/root.hints
    cp ${rootKey} $out/root.key
    cp ${rootDs} $out/root.ds
  '';

  meta = with lib; {
    description = "DNS root data including root zone and DNSSEC key";
    maintainers = with maintainers; [ fpletz veprbl ];
  };
}
