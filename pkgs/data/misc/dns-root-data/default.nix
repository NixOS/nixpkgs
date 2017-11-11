{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    url = "https://www.internic.net/domain/named.root";
    sha256 = "0vdrff4l8s8grif52dnh091s8qydhh88k25zqd9rj66sf1qwcwxl";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  name = "dns-root-data-2017-10-24";

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
