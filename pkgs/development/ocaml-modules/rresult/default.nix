{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-rresult-${version}";
	version = "0.5.0";
	src = fetchurl {
		url = "http://erratique.ch/software/rresult/releases/rresult-${version}.tbz";
		sha256 = "1xxycxhdhaq8p9vhwi93s2mlxjwgm44fcxybx5vghzgbankz9yhm";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild topkg opam ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		license = stdenv.lib.licenses.isc;
		homepage = http://erratique.ch/software/rresult;
		description = "Result value combinators for OCaml";
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
