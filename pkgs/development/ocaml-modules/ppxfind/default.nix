{ stdenv, lib, buildDunePackage, fetchurl, ocaml, ocaml-migrate-parsetree }:

buildDunePackage (rec {
	pname = "ppxfind";
	version = "1.3";
	src = fetchurl {
		url = "https://github.com/diml/ppxfind/releases/download/${version}/ppxfind-${version}.tbz";
		sha256 = "1r4jp0516378js62ss50a9s8ql2pm8lfdd3mnk214hp7s0kb17fl";
	};

	minimumOCamlVersion = "4.03";

	buildInputs = [ ocaml-migrate-parsetree ];

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

	meta = {
		homepage = "https://github.com/diml/ppxfind";
		description = "ocamlfind ppx tool";
		license = lib.licenses.bsd3;
		maintainers = [ lib.maintainers.vbgl ];
	};
} // (
if lib.versions.majorMinor ocaml.version == "4.04" then {
  dontStrip = true;
} else {}
))
