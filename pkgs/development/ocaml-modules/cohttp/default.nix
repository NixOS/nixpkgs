{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, fmt, alcotest
, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "5.3.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    hash = "sha256-9eJz08Lyn/R71+Ftsj4fPWzQGkC+ACCJhbxDTIjUV2s=";
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
