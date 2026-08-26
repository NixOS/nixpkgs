{
  buildDunePackage,
  tls,
  lwt,
  mirage-crypto-rng,
}:

buildDunePackage {
  pname = "tls-lwt";

  inherit (tls) src meta version;

  doCheck = true;

  propagatedBuildInputs = [
    lwt
    mirage-crypto-rng
    tls
  ];
}
