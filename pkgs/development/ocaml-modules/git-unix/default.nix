{ stdenv, ocaml, findlib, dune, git-http
, cohttp-lwt-unix
, tls, cmdliner, mtime
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-unix-${version}";
	inherit (git-http) version src;

	buildInputs = [ ocaml findlib dune cmdliner mtime ];

	propagatedBuildInputs = [ cohttp-lwt-unix git-http tls ];

	buildPhase = "dune build -p git-unix";

	inherit (dune) installPhase;

	meta = {
		description = "Unix backend for the Git protocol(s)";
		inherit (git-http.meta) homepage license maintainers platforms;
	};
}
