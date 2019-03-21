{ stdenv, fetchurl, buildDunePackage, ppx_sexp_conv, ounit
, re, sexplib, stringext
}:

buildDunePackage rec {
  pname = "uri";
  version = "1.9.6";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "1m845rwd70wi4iijkrigyz939m1x84ba70hvv0d9sgk6971w4kz0";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv re sexplib stringext ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
