{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "6.2.3";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-${version}.tbz";
    hash = "sha256-OkaEuxSFsfJH1ghN0KNW4QJ+ksLNRns1yr1Zp2RCPnk=";
  };

  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri ppx_sexp_conv ];

  meta = {
    description = "Network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
