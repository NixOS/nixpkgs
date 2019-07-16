{ lib, fetchurl, buildDunePackage, ppx_sexp_conv, ounit
, re, sexplib0, stringext
}:

buildDunePackage rec {
  pname = "uri";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1q0xmc93l46dilxclkmai7w952bdi745rhvsx5vissaigcj9wbwi";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv re sexplib0 stringext ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
