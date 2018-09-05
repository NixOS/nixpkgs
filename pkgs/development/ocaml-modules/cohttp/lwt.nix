{ stdenv, ocaml, findlib, dune, cohttp, lwt3, uri, ppx_sexp_conv }:

if !stdenv.lib.versionAtLeast cohttp.version "0.99"
then cohttp
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-cohttp-lwt-${version}";
	inherit (cohttp) version src installPhase meta;

	buildInputs = [ ocaml findlib dune uri ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp lwt3 ];

	buildPhase = "dune build -p cohttp-lwt";
}
