{ lib, buildDunePackage, alcotest, cstruct, sexplib }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage rec {
	pname = "cstruct-sexp";
	inherit (cstruct) version src meta;

	doCheck = true;
	checkInputs = lib.optional doCheck alcotest;

	propagatedBuildInputs = [ cstruct sexplib ];
}

