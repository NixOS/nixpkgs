{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    url = "https://www.internic.net/domain/named.root";
    sha256 = "05nlfqvny1hy2kwaf03qb7bwcpxncfp6ds0b14symqgl9csziz1i";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  name = "dns-root-data-2017-11-16";

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
