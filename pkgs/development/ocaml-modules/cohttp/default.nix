{ lib, fetchurl, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv, stdlib-shims
, base64, fieldslib, jsonm, re, stringext, uri-sexp
}:

buildDunePackage rec {
	pname = "cohttp";
	version = "2.5.1";

	src = fetchurl {
		url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
		sha256 = "0im91mi3nxzqfd7fs5r0zg5gsparfnf5zaz13mpw247hkd3y3396";
	};

	buildInputs = [ jsonm ppx_fields_conv ppx_sexp_conv ];

	propagatedBuildInputs = [ base64 fieldslib re stringext uri-sexp stdlib-shims ];

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://github.com/mirage/ocaml-cohttp";
	};
}
