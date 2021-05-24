{ buildDunePackage, tls
, x509, lwt, fmt, mirage-flow, mirage-kv, mirage-clock, ptime
, mirage-crypto, mirage-crypto-pk, mirage-crypto-ec
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
    mirage-crypto-ec
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
