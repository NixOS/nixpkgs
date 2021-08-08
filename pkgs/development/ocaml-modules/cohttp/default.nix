{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "4.0.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
    sha256 = "bd7aa4cd2c82744990ed7c49e3ee7a40324c64cb3d8509804809155e2bacd1d2";
  };

  buildInputs = [ jsonm ppx_sexp_conv ];

  propagatedBuildInputs = [ base64 re stringext uri-sexp ];

  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ fmt alcotest ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
