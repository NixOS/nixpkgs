{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    url = "http://www.internic.net/domain/named.root";
    sha256 = "1zf3ydn44z70gq1kd95lvk9cp68xlbl8vqpswqlhd30qafx6v6d1";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  name = "dns-root-data-2017-07-11";

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
