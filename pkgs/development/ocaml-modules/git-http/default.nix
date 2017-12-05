{ stdenv, ocaml, findlib, jbuilder, git, cohttp }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-http-${version}";
	inherit (git) version src;

	buildInputs = [ ocaml findlib jbuilder ];

	propagatedBuildInputs = [ git cohttp ];

	buildPhase = "jbuilder build -p git-http";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Client implementation of the “Smart” HTTP Git protocol in pure OCaml";
		inherit (git.meta) homepage license maintainers platforms;
	};
}
