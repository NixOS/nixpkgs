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
, cstruct
}:

buildDunePackage {
  pname = "letsencrypt-app";

  inherit (letsencrypt)
    src
    version
    useDune2
    minimalOCamlVersion
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
    cstruct
  ];

  meta = letsencrypt.meta // {
    description = "An ACME client implementation of the ACME protocol (RFC 8555) for OCaml";
  };
}
