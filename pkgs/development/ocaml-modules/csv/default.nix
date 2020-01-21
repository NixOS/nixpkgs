{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "csv";
	version = "2.4";

	src = fetchurl {
		url = "https://github.com/Chris00/ocaml-${pname}/releases/download/${version}/csv-${version}.tbz";
		sha256 = "13m9n8mdss6jfbiw7d5bybxn4n85vmg4zw7dc968qrgjfy0w9zhk";
	};

	meta = {
		description = "A pure OCaml library to read and write CSV files";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		homepage = https://github.com/Chris00/ocaml-csv;
	};
}
