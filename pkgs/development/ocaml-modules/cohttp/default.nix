{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "5.1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
    sha256 = "sha256-mINgeBO7DSsWd84gYjQNUQFqbh8KBZ+S2bYI/iVWMAc=";
  };

  buildInputs = [ jsonm ppx_sexp_conv ];

  propagatedBuildInputs = [ base64 re stringext uri-sexp ];

  doCheck = true;
  checkInputs = [ fmt alcotest crowbar ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
