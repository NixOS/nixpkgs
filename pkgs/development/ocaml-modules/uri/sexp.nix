{ lib, ocaml, buildDunePackage, uri, ounit, ppx_sexp_conv, sexplib0 }:

if !lib.versionAtLeast ocaml.version "4.04"
then throw "uri-sexp is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "uri-sexp";
  inherit (uri) version src doCheck meta;

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv sexplib0 uri ];
}
