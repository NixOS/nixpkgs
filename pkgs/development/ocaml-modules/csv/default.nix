{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "csv";
	version = "2.2";

	src = fetchurl {
		url = "https://github.com/Chris00/ocaml-${pname}/releases/download/${version}/csv-${version}.tbz";
		sha256 = "1llwjdi14vvfy4966crapibq0djii71x47b0yxhjcl5jw4xnsaha";
	};

	meta = {
		description = "A pure OCaml library to read and write CSV files";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		homepage = https://github.com/Chris00/ocaml-csv;
	};
}
