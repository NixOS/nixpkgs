{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    url = "https://www.internic.net/domain/named.root";
    sha256 = "0qsyxpj5b3i7n162qfyv76ljqbvnwjii7jk8mpfinklx0sk01473";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  name = "dns-root-data-2017-07-26";

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
