{ stdenv, ocaml, cstruct, ppx_tools_versioned }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ppx_cstruct-${version}";
	inherit (cstruct) version src unpackCmd installPhase meta;

	buildInputs = cstruct.buildInputs ++ [ ppx_tools_versioned ];
	propagatedBuildInputs = [ cstruct ];

	buildPhase = "dune build -p ppx_cstruct";
}
