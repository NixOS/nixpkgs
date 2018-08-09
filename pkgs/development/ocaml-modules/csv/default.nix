{ stdenv, fetchurl, ocaml, findlib, jbuilder }:

stdenv.mkDerivation rec {
	version = "2.1";
	name = "ocaml${ocaml.version}-csv-${version}";
	src = fetchurl {
		url = "https://github.com/Chris00/ocaml-csv/releases/download/2.1/csv-2.1.tbz";
		sha256 = "0cgfb6cwhwy7ypc1i3jyfz6sdnykp75aqi6kk0g1a2d81yjwzbcg";
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
