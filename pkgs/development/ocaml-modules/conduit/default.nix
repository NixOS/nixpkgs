{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri, logs
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "4.0.1";
  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-v${version}.tbz";
    sha256 = "500d95bf2a524f4851e94373e32d26b6e99ee04e5134db69fe6e151c3aad9b1f";
  };

  buildInputs = [ ppx_sexp_conv ];
  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri logs ];

  meta = {
    description = "A network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
