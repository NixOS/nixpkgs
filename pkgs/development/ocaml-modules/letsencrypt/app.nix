{ lib
, buildDunePackage
, letsencrypt
, letsencrypt-dns
, cmdliner
, cohttp-lwt-unix
, logs
, fmt
, lwt
, mirage-crypto-rng
, ptime
, bos
, fpath
, randomconv
}:

buildDunePackage {
  pname = "letsencrypt-app";

  inherit (letsencrypt)
    src
    version
    useDune2
    minimumOCamlVersion
    ;

  buildInputs = [
    letsencrypt
    letsencrypt-dns
    cmdliner
    cohttp-lwt-unix
    logs
    fmt
    lwt
    mirage-crypto-rng
    ptime
    bos
    fpath
    randomconv
  ];

  meta = letsencrypt.meta // {
    description = "An ACME client implementation of the ACME protocol (RFC 8555) for OCaml";
  };
}
