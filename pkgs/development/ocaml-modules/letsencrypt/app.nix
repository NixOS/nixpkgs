{
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
}:

buildDunePackage {
  pname = "letsencrypt-app";
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
  ];

  meta = letsencrypt.meta // {
    description = "ACME client implementation of the ACME protocol (RFC 8555) for OCaml";
    mainProgram = "oacmel";
  };
}
