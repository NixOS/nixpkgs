{ lib, fetchurl, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv, stdlib-shims
, base64, fieldslib, jsonm, re, stringext, uri-sexp
}:

buildDunePackage rec {
	pname = "cohttp";
	version = "2.5.4";

	useDune2 = true;

	minimumOCamlVersion = "4.04.1";

	src = fetchurl {
		url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
		sha256 = "1q04spmki5zis5p5m1vs77i3k7ijm134j62g61071vblwx25z17a";
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
