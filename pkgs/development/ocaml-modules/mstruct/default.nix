{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, opam
, cstruct
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "mstruct is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	version = "1.3.3";
	name = "ocaml${ocaml.version}-mstruct-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-mstruct";
		rev = "v${version}";
		sha256 = "1rxjzkg6156vl6yazbk1h0ndqj80wym5aliaapijf60apqqmsp4s";
	};

	buildInputs = [ ocaml findlib jbuilder opam ];

	propagatedBuildInputs = [ cstruct ];

	inherit (jbuilder) installPhase;

	meta = {
		description = "A thin mutable layer on top of cstruct";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
