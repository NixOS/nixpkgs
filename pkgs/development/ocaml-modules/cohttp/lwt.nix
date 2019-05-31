{ stdenv, buildDunePackage, cohttp, ocaml_lwt, uri, ppx_sexp_conv, logs }:

if !stdenv.lib.versionAtLeast cohttp.version "0.99"
then cohttp
else

buildDunePackage rec {
	pname = "cohttp-lwt";
	inherit (cohttp) version src meta;

	buildInputs = [ uri ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp ocaml_lwt logs ];
}
