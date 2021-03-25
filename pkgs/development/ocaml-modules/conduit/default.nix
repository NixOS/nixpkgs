{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, sexplib, astring, uri, logs
, ipaddr, ipaddr-sexp
}:

buildDunePackage rec {
  pname = "conduit";
  version = "2.2.2";
  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v2.2.2/conduit-v2.2.2.tbz";
    sha256 = "1zb83w2pq9c8xrappfxa6y5q93772f5dj22x78camsm77a2c2z55";
  };

  buildInputs = [ ppx_sexp_conv ];
  propagatedBuildInputs = [ astring ipaddr ipaddr-sexp sexplib uri ];

  meta = {
    description = "A network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
