{ stdenv, lib, buildDunePackage, fetchurl, ocaml, ocaml-migrate-parsetree }:

buildDunePackage (rec {
	pname = "ppxfind";
	version = "1.4";
	src = fetchurl {
		url = "https://github.com/diml/ppxfind/releases/download/${version}/ppxfind-${version}.tbz";
		sha256 = "0wa9vcrc26kirc2cqqs6kmarbi8gqy3dgdfiv9y7nzsgy1liqacq";
	};

	minimumOCamlVersion = "4.03";
	useDune2 = true;

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
