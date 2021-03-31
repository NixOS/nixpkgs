{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri, logs
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "2.3.0";
  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-v${version}.tbz";
    sha256 = "df52c4c0967ee8dfd044feca3cb90755132a5bc40e6b2884f64bf2d13755e72d";
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
