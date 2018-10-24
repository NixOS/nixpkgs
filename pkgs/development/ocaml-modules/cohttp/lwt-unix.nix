{ stdenv, ocaml, findlib, dune, cohttp-lwt
, conduit-lwt-unix, ppx_sexp_conv
, cmdliner, fmt, magic-mime
}:

if !stdenv.lib.versionAtLeast cohttp-lwt.version "0.99"
then cohttp-lwt
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-cohttp-lwt-unix-${version}";
	inherit (cohttp-lwt) version src installPhase meta;

	buildInputs = [ ocaml findlib dune cmdliner ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp-lwt conduit-lwt-unix fmt magic-mime ];

	buildPhase = "dune build -p cohttp-lwt-unix";
}
