{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, ppx_fields_conv, ppx_sexp_conv, ppx_deriving
, base64, fieldslib, jsonm, re, stringext, uri
}:

stdenv.mkDerivation rec {
	version = "1.1.1";
	name = "ocaml${ocaml.version}-cohttp-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-cohttp";
		rev = "v${version}";
		sha256 = "1dzd6vy43b7p9xplzg2whylz5br59zxaqywa14b4l377f31gnwq1";
	};

	buildInputs = [ ocaml findlib dune jsonm ppx_fields_conv ppx_sexp_conv ];

	propagatedBuildInputs = [ ppx_deriving base64 fieldslib re stringext uri ];

	buildPhase = "dune build -p cohttp";

	inherit (dune) installPhase;

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
