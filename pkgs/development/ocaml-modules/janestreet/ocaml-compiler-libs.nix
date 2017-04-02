{ stdenv, fetchurl, ocaml, jbuilder, findlib }:

stdenv.mkDerivation {
	name = "ocaml${ocaml.version}-ocaml-compiler-libs-0.9.0"; 
	src = fetchurl {
		url = http://ocaml.janestreet.com/ocaml-core/v0.9/files/ocaml-compiler-libs-v0.9.0.tar.gz;
		sha256 = "0ipi56vg227924ahi9vv926jn16br9zfipm6a3xd4xrl5pxkvzaz";
	};

	buildInputs = [ ocaml jbuilder findlib ];

	inherit (jbuilder) installPhase;

	meta = {
		description = "OCaml compiler libraries repackaged";
		homepage = https://github.com/janestreet/ocaml-compiler-libs;
		license = stdenv.lib.licenses.asl20;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
