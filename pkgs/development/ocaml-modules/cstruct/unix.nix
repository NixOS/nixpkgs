{ stdenv, ocaml, cstruct }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-cstruct-unix-${version}";
	inherit (cstruct) version src unpackCmd buildInputs installPhase meta;

	propagatedBuildInputs = [ cstruct ];

	buildPhase = "${cstruct.buildPhase}-unix";
}
