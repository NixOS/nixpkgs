{ lib
, buildDunePackage
, letsencrypt
, letsencrypt-dns
, cmdliner_1_1
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
    minimumOCamlVersion
    ;

  buildInputs = [
    letsencrypt
    letsencrypt-dns
    cmdliner_1_1
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
    mainProgram = "oacmel";
  };
}
