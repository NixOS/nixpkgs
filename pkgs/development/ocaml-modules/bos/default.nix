{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, astring, fmt, fpath, logs, rresult
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-bos-${version}";
	version = "0.1.6";
	src = fetchurl {
		url = "http://erratique.ch/software/bos/releases/bos-${version}.tbz";
		sha256 = "1z9sbziqddf770y94pd0bffsp1wdr1v3kp2p00pr27adv7h7dgls";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild opam topkg ];
	propagatedBuildInputs = [ astring fmt fpath logs rresult ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "Basic OS interaction for OCaml";
		homepage = http://erratique.ch/software/bos;
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
