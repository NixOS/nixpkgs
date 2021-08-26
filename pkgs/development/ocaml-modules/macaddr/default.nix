{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ounit
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.1.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-v${version}.tbz";
    sha256 = "7e9328222c1a5f39b0751baecd7e27a842bdb0082fd48126eacbbad8816fbf5a";
  };

  checkInputs = [ ppx_sexp_conv ounit ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
