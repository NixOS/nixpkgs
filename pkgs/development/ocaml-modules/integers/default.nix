{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, opam }:

stdenv.mkDerivation {
	name = "ocaml${ocaml.version}-integers-0.2.2";

	src = fetchurl {
		url = https://github.com/ocamllabs/ocaml-integers/releases/download/v0.2.2/integers-0.2.2.tbz;
		sha256 = "08b1ljw88ny3l0mdq6xmffjk8anfc77igryva5jz1p6f4f746ywk";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild topkg opam ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "Various signed and unsigned integer types for OCaml";
		license = stdenv.lib.licenses.mit;
		homepage = https://github.com/ocamllabs/ocaml-integers;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
