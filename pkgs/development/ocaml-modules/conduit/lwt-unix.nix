{ stdenv, ocaml, findlib, jbuilder, conduit-lwt
, logs, ppx_sexp_conv
}:

if !stdenv.lib.versionAtLeast conduit-lwt.version "1.0"
then conduit-lwt
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-conduit-lwt-unix-${version}";
	inherit (conduit-lwt) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ppx_sexp_conv ];

	propagatedBuildInputs = [ conduit-lwt logs ];

	buildPhase = "jbuilder build -p conduit-lwt-unix";
}
