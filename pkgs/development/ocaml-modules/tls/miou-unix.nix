{
  buildDunePackage,
  crowbar,
  hxd,
  miou,
  mirage-crypto-rng-miou-unix,
  ohex,
  ptime,
  rresult,
  tls,
  x509,
}:

buildDunePackage {
  pname = "tls-miou-unix";
  inherit (tls) src version;

  propagatedBuildInputs = [
    miou
    tls
    x509
  ];

  doCheck = true;
  checkInputs = [
    crowbar
    hxd
    mirage-crypto-rng-miou-unix
    ohex
    ptime
    rresult
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, Miou+Unix layer";
  };
}
