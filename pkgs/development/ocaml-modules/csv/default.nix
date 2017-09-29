{ stdenv, fetchurl, ocaml, findlib, jbuilder }:

stdenv.mkDerivation rec {
	version = "2.0";
	name = "ocaml${ocaml.version}-csv-${version}";
	src = fetchurl {
		url = "https://github.com/Chris00/ocaml-csv/releases/download/2.0/csv-2.0.tbz";
		sha256 = "1g6xsybwc5ifr7n4hkqlh3294njzca12xg86ghh6pqy350wpq1zp";
	};

	unpackCmd = "tar -xjf $src";

	buildInputs = [ ocaml findlib jbuilder ];

	buildPhase = "jbuilder build -p csv";

	inherit (jbuilder) installPhase;

	meta = {
		description = "A pure OCaml library to read and write CSV files";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		homepage = https://github.com/Chris00/ocaml-csv;
		inherit (ocaml.meta) platforms;
	};
}
