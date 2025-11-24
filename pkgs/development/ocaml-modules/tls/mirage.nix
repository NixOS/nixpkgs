{
  buildDunePackage,
  tls,
  fmt,
  lwt,
  mirage-crypto,
  mirage-crypto-pk,
  mirage-flow,
  mirage-kv,
  mirage-ptime,
  ptime,
}:

buildDunePackage {
  pname = "tls-mirage";
  inherit (tls) src version;

  propagatedBuildInputs = [
    fmt
    lwt
    mirage-crypto
    mirage-crypto-pk
    mirage-flow
    mirage-kv
    mirage-ptime
    ptime
    tls
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
