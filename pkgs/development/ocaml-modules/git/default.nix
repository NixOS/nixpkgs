{ stdenv, fetchFromGitHub, buildDunePackage
, astring, decompress, fmt, hex, logs, mstruct, ocaml_lwt, ocamlgraph, ocplib-endian, uri
, alcotest, mtime, nocrypto
}:

buildDunePackage rec {
  pname = "git";
	version = "1.11.5";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-git";
		rev = version;
		sha256 = "0r1bxpxjjnl9hh8xbabsxl7svzvd19hfy73a2y1m4kljmw64dpfh";
	};

	buildInputs = [ alcotest mtime nocrypto ];
	propagatedBuildInputs = [ astring decompress fmt hex logs mstruct ocaml_lwt ocamlgraph ocplib-endian uri ];
	doCheck = true;

	meta = {
		description = "Git format and protocol in pure OCaml";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
