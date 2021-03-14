{ buildDunePackage, tls
, x509, lwt, fmt, mirage-flow, mirage-kv, mirage-clock, ptime
, mirage-crypto, mirage-crypto-pk, hacl_x25519, fiat-p256
}:

buildDunePackage {
  pname = "tls-mirage";

  inherit (tls) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    tls
    x509
    lwt
    fmt
    mirage-flow
    mirage-kv
    mirage-clock
    ptime
    mirage-crypto
    mirage-crypto-pk
    hacl_x25519
    fiat-p256
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
