{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "octavius is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation {
	name = "ocaml${ocaml.version}-octavius-0.2.0";
	src = fetchurl {
		url = https://github.com/ocaml-doc/octavius/releases/download/v0.2.0/octavius-0.2.0.tbz;
		sha256 = "02milzzlr4xk5aymg2fjz27f528d5pyscqvld3q0dm41zcpkz5ml";
	};

	buildInputs = [ ocaml findlib ocamlbuild topkg ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "Ocamldoc comment syntax parser";
		homepage = https://github.com/ocaml-doc/octavius;
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
