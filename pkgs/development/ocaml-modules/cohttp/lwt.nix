{ lib, buildDunePackage, cohttp, ocaml_lwt, uri, ppx_sexp_conv, logs }:

if !lib.versionAtLeast cohttp.version "0.99"
then cohttp
else if !lib.versionAtLeast ppx_sexp_conv.version "0.13"
then throw "cohttp-lwt is not available for ppx_sexp_conv version ${ppx_sexp_conv.version}"
else

buildDunePackage {
	pname = "cohttp-lwt";
	inherit (cohttp) version src useDune2 meta;

	buildInputs = [ uri ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp ocaml_lwt logs ];
}
