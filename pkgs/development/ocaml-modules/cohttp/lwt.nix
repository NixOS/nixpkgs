{ stdenv, ocaml, findlib, dune, cohttp, ocaml_lwt, uri, ppx_sexp_conv }:

if !stdenv.lib.versionAtLeast cohttp.version "0.99"
then cohttp
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-cohttp-lwt-${version}";
	inherit (cohttp) version src installPhase meta;

	buildInputs = [ ocaml findlib dune uri ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp ocaml_lwt ];

	buildPhase = "dune build -p cohttp-lwt";
}
