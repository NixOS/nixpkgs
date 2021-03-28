{ lib, fetchurl, buildDunePackage
, ppx_fields_conv, ppx_sexp_conv, stdlib-shims
, base64, fieldslib, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "2.5.5";

  useDune2 = true;

  minimumOCamlVersion = "4.04.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
    sha256 = "0ywmql4lp6ps2gd064ixbjzsdnnn5vk3pipm005sswl553qqwaim";
  };

  buildInputs = [ jsonm ppx_fields_conv ppx_sexp_conv ];

  propagatedBuildInputs = [ base64 fieldslib re stringext uri-sexp stdlib-shims ];

  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ fmt alcotest ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
