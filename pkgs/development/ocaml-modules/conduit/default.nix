{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri, logs
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "4.0.2";
  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-v${version}.tbz";
    sha256 = "2a37ffaa352a1e145ef3d80ac28661213c69a741b238623e59f29e3d5a12c537";
  };

  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri logs ppx_sexp_conv ];

  meta = {
    description = "A network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
