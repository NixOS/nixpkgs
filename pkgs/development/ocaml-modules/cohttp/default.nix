{ lib, fetchurl, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv, ppx_compare, stdlib-shims
, base64, fieldslib, jsonm, re, stringext, uri-sexp
}:

buildDunePackage rec {
	pname = "cohttp";
	version = "3.0.0";

	useDune2 = true;

	minimumOCamlVersion = "4.04.1";

	src = fetchurl {
		url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
		sha256 = "191fr2pxqydnmznx7fgc2hk4lyffrf6c2al2pcvc7jdbg91jz1zv";
	};

	buildInputs = [ jsonm ppx_fields_conv ppx_sexp_conv ];

	propagatedBuildInputs = [ base64 fieldslib re stringext uri-sexp stdlib-shims ppx_compare ];

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://github.com/mirage/ocaml-cohttp";
	};
}
