{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, opam
, astring, decompress, fmt, hex, logs, mstruct, ocaml_lwt, ocamlgraph, uri
}:

stdenv.mkDerivation rec {
	version = "1.11.1";
	name = "ocaml${ocaml.version}-git-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-git";
		rev = version;
		sha256 = "04az2bpbhgdhh7y6pagqx4wf3jbmqrm8w20dgimpbj5h3hnak744";
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
