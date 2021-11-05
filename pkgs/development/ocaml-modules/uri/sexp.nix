{ lib, ocaml, buildDunePackage, uri, ounit, ppx_sexp_conv, sexplib0 }:

buildDunePackage {
  pname = "uri-sexp";
  inherit (uri) version useDune2 src meta;
  minimumOCamlVersion = "4.04";

  checkInputs = [ ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv sexplib0 uri ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";
}
