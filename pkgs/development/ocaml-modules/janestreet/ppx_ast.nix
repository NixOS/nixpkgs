{ stdenv, fetchurl, ocaml, jbuilder, findlib
, ocaml-compiler-libs, ocaml-migrate-parsetree
}:

stdenv.mkDerivation {
	name = "ocaml${ocaml.version}-ppx_ast-0.9.0";
	src = fetchurl {
		url = http://ocaml.janestreet.com/ocaml-core/v0.9/files/ppx_ast-v0.9.0.tar.gz;
		sha256 = "1hirfmxr8hkf3p39k1pqidabxxhd541d6ddfaqpgxbl51bw9ddmz";
	};

	buildInputs = [ ocaml jbuilder findlib ];
	propagatedBuildInputs = [ ocaml-compiler-libs ocaml-migrate-parsetree ];

	inherit (jbuilder) installPhase;

	meta = {
		description = "OCaml AST used by Jane Street ppx rewriters";
		homepage = https://github.com/janestreet/ppx_ast;
		license = stdenv.lib.licenses.asl20;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
