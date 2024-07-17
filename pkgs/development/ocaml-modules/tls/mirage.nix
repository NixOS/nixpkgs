{
  buildDunePackage,
  tls,
  fmt,
  lwt,
  mirage-clock,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-flow,
  mirage-kv,
  ptime,
  x509,
}:

buildDunePackage {
  pname = "tls-mirage";
  inherit (tls) src version;

  propagatedBuildInputs = [
    fmt
    lwt
    mirage-clock
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-flow
    mirage-kv
    ptime
    tls
    x509
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
