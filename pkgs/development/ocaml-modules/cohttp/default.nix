{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest, uri, sexplib0, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "5.0.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    sha256 = "sha256-/W/0uGyBg1XWGzoIYoWW2/UX1qfabo7exIG7BlPKWgU=";
  };

  buildInputs = [ jsonm ppx_sexp_conv ];

  propagatedBuildInputs = [ base64 re stringext uri-sexp uri sexplib0 ];

  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ fmt alcotest crowbar ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
