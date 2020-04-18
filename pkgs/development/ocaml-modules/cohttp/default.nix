{ lib, fetchFromGitHub, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv
, base64, fieldslib, jsonm, re, stringext, uri-sexp
}:

buildDunePackage rec {
  pname = "cohttp";
	version = "2.1.3";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-cohttp";
		rev = "v${version}";
		sha256 = "16k4ldmz6ljryhr139adlma130frb5wh13qswkrwc5gxx6d2wh8d";
	};

	buildInputs = [ jsonm ppx_fields_conv ppx_sexp_conv ];

	propagatedBuildInputs = [ base64 fieldslib re stringext uri-sexp ];

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
