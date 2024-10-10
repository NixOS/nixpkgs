{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "7.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-${version}.tbz";
    hash = "sha256-WNIhigfnFwYCXeOMoCUyM+lw81tMrNN/cGlBtMvqV/c=";
  };

  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri ppx_sexp_conv ];

  meta = {
    description = "Network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
