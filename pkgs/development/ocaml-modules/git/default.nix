{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, opam
, astring, decompress, fmt, hex, logs, mstruct, ocaml_lwt, ocamlgraph, uri
}:

stdenv.mkDerivation rec {
	version = "1.11.2";
	name = "ocaml${ocaml.version}-git-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-git";
		rev = version;
		sha256 = "1z5b0g4vck1sh1w076i2p3ppxrmb9h30q3nip5snw2r9prkm6y1j";
	};

	buildInputs = [ ocaml findlib jbuilder ];

	propagatedBuildInputs = [ astring decompress fmt hex logs mstruct ocaml_lwt ocamlgraph uri ];

	buildPhase = "jbuilder build -p git";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Git format and protocol in pure OCaml";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
