{ stdenv, ocaml, findlib, dune, conduit-lwt
, logs, ppx_sexp_conv, lwt_ssl
}:

if !stdenv.lib.versionAtLeast conduit-lwt.version "1.0"
then conduit-lwt
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-conduit-lwt-unix-${version}";
	inherit (conduit-lwt) version src installPhase meta;

	buildInputs = [ ocaml findlib dune ppx_sexp_conv ];

	propagatedBuildInputs = [ conduit-lwt logs lwt_ssl ];

	buildPhase = "dune build -p conduit-lwt-unix";
}
