{ stdenv, lib, fetchFromGitHub, fetchpatch, ocaml, findlib, withStatic ? false }:

stdenv.mkDerivation rec {
	version = "1.1";
	name = "ocaml${ocaml.version}-num-${version}";
	src = fetchFromGitHub {
		owner = "ocaml";
		repo = "num";
		rev = "v${version}";
		sha256 = "0a4mhxgs5hi81d227aygjx35696314swas0vzy3ig809jb7zq4h0";
	};

	patches = [ (fetchpatch {
			url = "https://github.com/ocaml/num/commit/6d4c6d476c061298e6385e8a0864f083194b9307.patch";
			sha256 = "18zlvb5n327q8y3c52js5dvyy29ssld1l53jqng8m9w1k24ypi0b";
		})
	] ++ lib.optional withStatic ./enable-static.patch;

	nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ ocaml findlib ];

	createFindlibDestdir = true;


	meta = {
		description = "Legacy Num library for arbitrary-precision integer and rational arithmetic";
		license = stdenv.lib.licenses.lgpl21;
		inherit (ocaml.meta) platforms;
		inherit (src.meta) homepage;
	};
}
