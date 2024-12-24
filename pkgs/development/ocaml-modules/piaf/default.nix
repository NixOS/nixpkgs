{
  alcotest,
  buildDunePackage,
  fetchurl,
  eio-ssl,
  faraday,
  h2-eio,
  httpun-eio,
  httpun-ws,
  ipaddr,
  ke,
  lib,
  logs,
  magic-mime,
  pecu,
  prettym,
  unstrctrd,
  uri,
  uutf,
  dune-site,
  eio_main,
}:

buildDunePackage rec {
  pname = "piaf";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/piaf/releases/download/${version}/piaf-${version}.tbz";
    hash = "sha256-B/qQCaUvrqrm2GEW51AH9SebGFx7x8laq5RV8hBzcPs=";
  };

  propagatedBuildInputs = [
    eio-ssl
    faraday
    h2-eio
    httpun-eio
    httpun-ws
    ipaddr
    logs
    magic-mime
    pecu
    prettym
    unstrctrd
    uri
    uutf
  ];

  # Some test cases fail
  doCheck = false;
  checkInputs = [
    alcotest
    dune-site
    eio_main
  ];

  meta = {
    description = "HTTP library with HTTP/2 support written entirely in OCaml";
    homepage = "https://github.com/anmonteiro/piaf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ anmonteiro ];
  };
}
