{ stdenv, fetchFromGitHub, ocaml, findlib, dune, cppo }:

stdenv.mkDerivation rec {
	version = "0.8.7";
	name = "ocaml${ocaml.version}-camomile-${version}";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = "camomile";
		rev = "rel-${version}";
		sha256 = "0rh58nl5jrnx01hf0yqbdcc2ncx107pq29zblchww82ci0x1xwsf";
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
