{ lib, buildDunePackage, fetchurl, ocaml-migrate-parsetree }:

buildDunePackage rec {
	pname = "ppxfind";
	version = "1.2";
	src = fetchurl {
		url = "https://github.com/diml/ppxfind/releases/download/${version}/ppxfind-${version}.tbz";
		sha256 = "1687jbgii5w5dvvid3ri2cx006ysv0rrspn8dz8x7ma8615whz2h";
	};

	minimumOCamlVersion = "4.03";

	buildInputs = [ ocaml-migrate-parsetree ];

	meta = {
		homepage = "https://github.com/diml/ppxfind";
		description = "ocamlfind ppx tool";
		license = lib.licenses.bsd3;
		maintainers = [ lib.maintainers.vbgl ];
	};
}
