{ lib, buildDunePackage, ocaml, alcotest, cstruct, sexplib }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage rec {
	pname = "cstruct-sexp";
	inherit (cstruct) version src meta;

	doCheck = lib.versionAtLeast ocaml.version "4.03";
	checkInputs = lib.optional doCheck alcotest;

	propagatedBuildInputs = [ cstruct sexplib ];
}

