{ lib, buildDunePackage, alcotest, cstruct, sexplib }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
	pname = "cstruct-sexp";
	inherit (cstruct) version src meta;

	doCheck = true;
	buildInputs = [ alcotest ];

	propagatedBuildInputs = [ cstruct sexplib ];
}

