{ stdenv, ocaml, findlib, jbuilder, ppx_sexp_conv, conduit, lwt3 }:

if !stdenv.lib.versionAtLeast conduit.version "1.0"
then conduit
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-conduit-lwt-${version}";
	inherit (conduit) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ppx_sexp_conv ];

	propagatedBuildInputs = [ conduit lwt3 ];

	buildPhase = "jbuilder build -p conduit-lwt";
}
