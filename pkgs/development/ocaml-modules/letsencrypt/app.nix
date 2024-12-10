{
  lib,
  buildDunePackage,
  letsencrypt,
  letsencrypt-dns,
  cmdliner,
  cohttp-lwt-unix,
  logs,
  fmt,
  lwt,
  mirage-crypto-rng,
  ptime,
  bos,
  fpath,
  randomconv,
  cstruct,
}:

buildDunePackage {
  pname = "letsencrypt-app";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  inherit (letsencrypt)
    src
    version
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
    mainProgram = "oacmel";
  };
}
