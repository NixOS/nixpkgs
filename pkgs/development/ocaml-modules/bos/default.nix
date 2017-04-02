{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, astring, fmt, fpath, logs, rresult
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-bos-${version}";
	version = "0.1.4";
	src = fetchurl {
		url = "http://erratique.ch/software/bos/releases/bos-${version}.tbz";
		sha256 = "1ly66lysk4w6mdy4k1n3ynlpfpq7lw4wshcpzgx58v6x613w5s7q";
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
