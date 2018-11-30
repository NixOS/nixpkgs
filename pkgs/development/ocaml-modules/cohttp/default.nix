{ stdenv, fetchFromGitHub, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv, ppx_deriving
, base64, fieldslib, jsonm, re, stringext, uri
}:

buildDunePackage rec {
  pname = "cohttp";
	version = "1.1.1";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-cohttp";
		rev = "v${version}";
		sha256 = "1dzd6vy43b7p9xplzg2whylz5br59zxaqywa14b4l377f31gnwq1";
	};

	buildInputs = [ jsonm ppx_fields_conv ppx_sexp_conv ];

	propagatedBuildInputs = [ ppx_deriving base64 fieldslib re stringext uri ];

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
