{ stdenv, ocaml, findlib, jbuilder, git-http
, ocaml_lwt, tls, conduit, magic-mime, cmdliner, mtime
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-unix-${version}";
	inherit (git-http) version src;

	buildInputs = [ ocaml findlib jbuilder cmdliner mtime ];

	propagatedBuildInputs = [ conduit git-http magic-mime ocaml_lwt tls ];

	buildPhase = "jbuilder build -p git-unix";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Unix backend for the Git protocol(s)";
		inherit (git-http.meta) homepage license maintainers platforms;
	};
}
