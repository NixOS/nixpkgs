{ lib, buildDunePackage, ocaml, alcotest, cstruct, sexplib }:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage rec {
  pname = "cstruct-sexp";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.03";

  # alcotest is only available on OCaml >= 4.05 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  propagatedBuildInputs = [ cstruct sexplib ];
}
