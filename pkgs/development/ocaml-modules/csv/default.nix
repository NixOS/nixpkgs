{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "csv";
	version = "2.1";

	src = fetchurl {
		url = "https://github.com/Chris00/ocaml-${pname}/releases/download/${version}/csv-${version}.tbz";
		sha256 = "0cgfb6cwhwy7ypc1i3jyfz6sdnykp75aqi6kk0g1a2d81yjwzbcg";
	};

	meta = {
		description = "A pure OCaml library to read and write CSV files";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		homepage = https://github.com/Chris00/ocaml-csv;
	};
}
