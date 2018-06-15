{ stdenv, fetchFromGitHub, ocaml, findlib, ocplib-endian, js_of_ocaml, uri }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ocplib-json-typed-${version}";
	version = "0.5";
	src = fetchFromGitHub {
		owner = "OCamlPro";
		repo = "ocplib-json-typed";
		rev = "v${version}";
		sha256 = "02c600wm2wdpzb66pivxzwjhqa2dm7dqyfvw3mbvkv1g2jj7kn2q";
	};

	buildInputs = [ ocaml findlib ocplib-endian js_of_ocaml ];
	propagatedBuildInputs = [ uri ];

	createFindlibDestdir = true;

	meta = {
		description = "A collection of type-aware JSON utilities for OCaml";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
