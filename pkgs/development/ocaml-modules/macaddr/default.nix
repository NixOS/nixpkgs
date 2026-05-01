{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  ppx_sexp_conv,
  ounit2,
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.6.2";

  minimalOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-${version}.tbz";
    hash = "sha256-CKP6bmQRSQtmYeWxAinqnsa4w3OOn2slWFmxPxRb4TY=";
  };

  checkInputs = [
    ppx_sexp_conv
    ounit2
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "Library for manipulation of MAC address representations";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
