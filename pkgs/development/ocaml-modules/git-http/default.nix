{ stdenv, ocaml, findlib, dune, git, cohttp-lwt
, alcotest, mtime, nocrypto
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-http-${version}";
	inherit (git) version src;

	buildInputs = [ ocaml findlib dune alcotest mtime nocrypto ];

	propagatedBuildInputs = [ git cohttp-lwt ];

	buildPhase = "dune build -p git-http";

	inherit (dune) installPhase;

	doCheck = true;
	checkPhase = "dune runtest -p git-http";

	meta = {
		description = "Client implementation of the “Smart” HTTP Git protocol in pure OCaml";
		inherit (git.meta) homepage license maintainers platforms;
	};
}
