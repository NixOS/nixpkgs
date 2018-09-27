{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, astring, decompress, fmt, hex, logs, mstruct, ocaml_lwt, ocamlgraph, uri
, alcotest, mtime, nocrypto
}:

stdenv.mkDerivation rec {
	version = "1.11.5";
	name = "ocaml${ocaml.version}-git-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-git";
		rev = version;
		sha256 = "0r1bxpxjjnl9hh8xbabsxl7svzvd19hfy73a2y1m4kljmw64dpfh";
	};

	buildInputs = [ ocaml findlib dune alcotest mtime nocrypto ];

	propagatedBuildInputs = [ astring decompress fmt hex logs mstruct ocaml_lwt ocamlgraph uri ];

	buildPhase = "dune build -p git";

	inherit (dune) installPhase;

	doCheck = true;
	checkPhase = "dune runtest -p git";

	meta = {
		description = "Git format and protocol in pure OCaml";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
