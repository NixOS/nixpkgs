{ stdenv, fetchFromGitHub, expat, ocaml, findlib, ounit }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-expat-${version}";
	version = "1.0.0";

	src = fetchFromGitHub {
		owner = "whitequark";
		repo = "ocaml-expat";
		rev = "v${version}";
		sha256 = "0rb47v08ra2hhh73p3d8sl4sizqwiwc37gnkl22b23sbwbjrpbz0";
	};

	prePatch = ''
		substituteInPlace Makefile --replace "gcc" "\$(CC)"
	'';

	buildInputs = [ ocaml findlib expat ounit ];

	doCheck = !stdenv.lib.versionAtLeast ocaml.version "4.06";
	checkTarget = "testall";

	createFindlibDestdir = true;

	meta = {
		description = "OCaml wrapper for the Expat XML parsing library";
		license = stdenv.lib.licenses.mit;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
