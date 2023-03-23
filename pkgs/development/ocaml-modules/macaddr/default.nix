{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ounit2
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.4.0";

  minimalOCamlVersion = "4.04";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-${version}.tbz";
    hash = "sha256-WmYpG/cQtF9+lVDs1WIievUZ1f7+iZ2hufsdD1HHNeo=";
  };

  checkInputs = [ ppx_sexp_conv ounit2 ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
