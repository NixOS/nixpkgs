{
  buildDunePackage,
  tls,
  fmt,
  lwt,
  mirage-clock,
  mirage-crypto,
  mirage-crypto-pk,
  mirage-flow,
  mirage-kv,
  ptime,
}:

buildDunePackage {
  pname = "tls-mirage";
  inherit (tls) src version;

  propagatedBuildInputs = [
    fmt
    lwt
    mirage-clock
    mirage-crypto
    mirage-crypto-pk
    mirage-flow
    mirage-kv
    ptime
    tls
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
