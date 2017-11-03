{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    url = "https://www.internic.net/domain/named.root";
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
    maintainers = with maintainers; [ fpletz ];
  };
}
