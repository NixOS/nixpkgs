{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, cstruct
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "mstruct is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	version = "1.4.0";
	name = "ocaml${ocaml.version}-mstruct-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-mstruct";
		rev = "v${version}";
		sha256 = "1p4ygwzs3n1fj4apfib0z0sabpph21bkq1dgjk4bsa59pq4prncm";
	};

	buildInputs = [ ocaml findlib dune ];

	propagatedBuildInputs = [ cstruct ];

	inherit (dune) installPhase;

	meta = {
		description = "A thin mutable layer on top of cstruct";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
