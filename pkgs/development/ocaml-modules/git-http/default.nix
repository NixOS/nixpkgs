{ stdenv, ocaml, findlib, jbuilder, git, cohttp-lwt
, alcotest, mtime, nocrypto
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-git-http-${version}";
	inherit (git) version src;

	buildInputs = [ ocaml findlib jbuilder alcotest mtime nocrypto ];

	propagatedBuildInputs = [ git cohttp-lwt ];

	buildPhase = "jbuilder build -p git-http";

	inherit (jbuilder) installPhase;

	doCheck = true;
	checkPhase = "jbuilder runtest -p git-http";

	meta = {
		description = "Client implementation of the “Smart” HTTP Git protocol in pure OCaml";
		inherit (git.meta) homepage license maintainers platforms;
	};
}
