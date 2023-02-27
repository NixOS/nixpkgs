{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "6.1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-${version}.tbz";
    sha256 = "sha256-ouKQiGMLvvksGpAhkqCVSKtKaz91p+7mciQm7KHvwF8=";
  };

  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri ppx_sexp_conv ];

  meta = {
    description = "A network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
