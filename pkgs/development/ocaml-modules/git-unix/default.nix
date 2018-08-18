{ stdenv, ocaml, findlib, jbuilder, git-http
, cohttp-lwt-unix
, tls, cmdliner, mtime
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-unix-${version}";
	inherit (git-http) version src;

	buildInputs = [ ocaml findlib jbuilder cmdliner mtime ];

	propagatedBuildInputs = [ cohttp-lwt-unix git-http tls ];

	buildPhase = "jbuilder build -p git-unix";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Unix backend for the Git protocol(s)";
		inherit (git-http.meta) homepage license maintainers platforms;
	};
}
