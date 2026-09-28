{
  alcotest,
  buildDunePackage,
  fetchurl,
  fetchpatch,
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

buildDunePackage (finalAttrs: {
  pname = "piaf";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/piaf/releases/download/${finalAttrs.version}/piaf-${finalAttrs.version}.tbz";
    hash = "sha256-B/qQCaUvrqrm2GEW51AH9SebGFx7x8laq5RV8hBzcPs=";
  };

  patches =
    # Compatibility with eio 1.4
    lib.optionals (lib.versionAtLeast eio_main.version "1.4") [
      (fetchpatch {
        url = "https://github.com/anmonteiro/piaf/commit/5b2f44683fb7eabdb78f43848c9e0a448e741fc3.patch";
        includes = [ "lib/*.ml" ];
        hash = "sha256-/Y3OQtqoA4DCgs3Ai2EPCipMb/xSwDAN7+6MTFoHKXI=";
      })
      (fetchpatch {
        url = "https://github.com/anmonteiro/piaf/commit/b8f5e94deea6e653025c37131bbf6833dc4c4c85.patch";
        includes = [ "lib/*.ml" ];
        hash = "sha256-gazYJFlM9OeuixpJnLwANZj/DVqdc8vacd1a6v35SpM=";
      })
    ];

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
    maintainers = [ ];
  };
})
