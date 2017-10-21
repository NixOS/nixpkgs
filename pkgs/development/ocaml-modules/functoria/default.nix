{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, bos, cmdliner, ocamlgraph
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "functoria is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-functoria-${version}";
	version = "2.0.2";
	src = fetchurl {
		url = "http://github.com/mirage/functoria/releases/download/${version}/functoria-${version}.tbz";
		sha256 = "019rl4rir4lwgjyqj2wq3ylw4daih1kxxgbc6ld6kzcq66mwr747";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild opam topkg ];
	propagatedBuildInputs = [ bos cmdliner ocamlgraph ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "A DSL to organize functor applications";
		homepage = https://github.com/mirage/functoria;
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
