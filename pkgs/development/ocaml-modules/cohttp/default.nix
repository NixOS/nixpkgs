{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "5.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    hash = "sha256-s72RxwTl6lEOkkuDqy7eH8RqLM5Eiw+M70iDuaFu7d0=";
  };

  postPatch = ''
    substituteInPlace cohttp/src/dune --replace 'bytes base64' 'base64'
  '';

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
