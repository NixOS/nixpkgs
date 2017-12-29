{ stdenv, ocaml, cstruct, lwt }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-cstruct-lwt-${version}";
	inherit (cstruct) version src unpackCmd buildInputs installPhase meta;

	propagatedBuildInputs = [ cstruct lwt ];

	buildPhase = "${cstruct.buildPhase}-lwt";
}
