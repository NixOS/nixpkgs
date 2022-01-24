{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ounit
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-v${version}.tbz";
    sha256 = "f98d237cc1f783a0ba7dff0c6c69b5f519fec056950e3e3e7c15e5511ee5b7ec";
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
