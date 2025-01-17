{
  lib,
  fetchurl,
  buildDunePackage,
  ppx_sexp_conv,
  cohttp-http,
  logs,
  base64,
  jsonm,
  re,
  stringext,
  uri-sexp,
  fmt,
  alcotest,
  ppx_expect,
  crowbar,
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "6.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    hash = "sha256-VMw0rxKLNC9K5gimaWUNZmYf/dUDJQ5N6ToaXvHvIqk=";
  };

  postPatch = ''
    substituteInPlace cohttp/src/dune --replace 'bytes base64' 'base64'
  '';

  buildInputs = [
    jsonm
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    base64
    re
    stringext
    uri-sexp
    cohttp-http
    logs
  ];

  doCheck = true;
  checkInputs = [
    fmt
    alcotest
    crowbar
    ppx_expect
  ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
