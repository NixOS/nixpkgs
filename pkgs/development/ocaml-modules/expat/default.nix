{ stdenv, fetchFromGitHub, expat, ocaml, findlib, ounit }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-expat-${version}";
	version = "1.1.0";

	src = fetchFromGitHub {
		owner = "whitequark";
		repo = "ocaml-expat";
		rev = "v${version}";
		sha256 = "07wm9663z744ya6z2lhiz5hbmc76kkipg04j9vw9dqpd1y1f2x3q";
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
