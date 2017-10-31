{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, cppo }:

stdenv.mkDerivation rec {
	version = "0.8.6";
	name = "ocaml${ocaml.version}-camomile-${version}";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = "camomile";
		rev = "rel-${version}";
		sha256 = "1jq1xhaikczk6lbvas7c35aa04q0kjaqd8m54c4jivpj80yvg4x9";
	};

	buildInputs = [ ocaml findlib jbuilder cppo ];

	configurePhase = "ocaml configure.ml --share $out/share/camomile";

	inherit (jbuilder) installPhase;

	meta = {
		inherit (ocaml.meta) platforms;
		inherit (src.meta) homepage;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		license = stdenv.lib.licenses.lgpl21;
		description = "A Unicode library for OCaml";
	};
}
