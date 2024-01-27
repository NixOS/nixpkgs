{ lib, buildDunePackage, ocaml, alcotest, cstruct, sexplib }:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage rec {
  pname = "cstruct-sexp";
  inherit (cstruct) version src meta;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  doCheck = true;
  checkInputs = [ alcotest ];

  propagatedBuildInputs = [ cstruct sexplib ];
}
