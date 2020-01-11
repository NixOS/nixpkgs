{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-rresult-${version}";
	version = "0.6.0";
	src = fetchurl {
		url = "https://erratique.ch/software/rresult/releases/rresult-${version}.tbz";
		sha256 = "1k69a3gvrk7f2cshwjzvk7818f0bwxhacgd14wxy6d4gmrggci86";
	};

	buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ result ];
  
	inherit (topkg) buildPhase installPhase;

	meta = {
		license = stdenv.lib.licenses.isc;
		homepage = https://erratique.ch/software/rresult;
		description = "Result value combinators for OCaml";
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
