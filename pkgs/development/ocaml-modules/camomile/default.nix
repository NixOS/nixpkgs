{ stdenv, fetchFromGitHub, ocaml, findlib, dune, cppo }:

stdenv.mkDerivation rec {
	version = "1.0.1";
	name = "ocaml${ocaml.version}-camomile-${version}";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = "camomile";
		rev = "${version}";
		sha256 = "1pfxr9kzkpd5bsdqrpxasfxkawwkg4cpx3m1h6203sxi7qv1z3fn";
	};

	buildInputs = [ ocaml findlib dune cppo ];

	configurePhase = "ocaml configure.ml --share $out/share/camomile";

	inherit (dune) installPhase;

	meta = {
		inherit (ocaml.meta) platforms;
		inherit (src.meta) homepage;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		license = stdenv.lib.licenses.lgpl21;
		description = "A Unicode library for OCaml";
	};
}
