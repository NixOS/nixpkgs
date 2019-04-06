{ lib, fetchurl, buildDunePackage, ppx_sexp_conv, ounit
, re, sexplib0, sexplib, stringext
, legacy ? false
}:

let params =
  if legacy then rec {
    version = "1.9.6";
    archive = version;
    sha256 = "1m845rwd70wi4iijkrigyz939m1x84ba70hvv0d9sgk6971w4kz0";
    inherit sexplib;
  } else rec {
    version = "2.2.0";
    archive = "v${version}";
    sha256 = "1q0xmc93l46dilxclkmai7w952bdi745rhvsx5vissaigcj9wbwi";
    sexplib = sexplib0;
  }
; in

buildDunePackage rec {
  pname = "uri";
  inherit (params) version;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-${params.archive}.tbz";
    inherit (params) sha256;
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv re params.sexplib stringext ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
