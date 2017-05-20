{ stdenv, fetchurl, ocaml, jbuilder, findlib }:

stdenv.mkDerivation {
	name = "ocaml${ocaml.version}-ppx_traverse_builtins-0.9.0";
	src = fetchurl {
		url = http://ocaml.janestreet.com/ocaml-core/v0.9/files/ppx_traverse_builtins-v0.9.0.tar.gz;
		sha256 = "0zmf9kybll0xn8dsj10v260l0zwjyykimqml9rl7xqyjyl1rmnx6";
	};

	buildInputs = [ ocaml jbuilder findlib ];

	inherit (jbuilder) installPhase;

	meta = {
		description = "Builtins for Ppx_traverse";
		homepage = https://github.com/janestreet/ppx_traverse_builtins;
		license = stdenv.lib.licenses.asl20;
		inherit (ocaml.meta) platforms;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
	};
}
