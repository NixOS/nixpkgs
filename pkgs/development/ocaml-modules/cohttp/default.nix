{
  lib,
  fetchurl,
  buildDunePackage,
  ppx_sexp_conv,
  base64,
  http,
  logs,
  re,
  stringext,
  uri-sexp,
  fmt,
  alcotest,
  crowbar,
  ppx_expect,
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "6.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    hash = "sha256-qBrElpnsRfWLPYXMTiJ0Eg0oRJ18IHWtsyNPBYPXbDM=";
  };

  buildInputs = [
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    base64
    http
    logs
    re
    stringext
    uri-sexp
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
