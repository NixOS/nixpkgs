{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, topkg, opam
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "decompress is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	version = "0.6";
	name = "ocaml${ocaml.version}-decompress-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "decompress";
		rev = "v${version}";
		sha256 = "0hfs5zrvimzvjwdg57vrxx9bb7irvlm07dk2yv3s5qhj30zimd08";
	};

	buildInputs = [ ocaml findlib ocamlbuild topkg opam ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "Pure OCaml implementation of Zlib";
		license = stdenv.lib.licenses.mit;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
