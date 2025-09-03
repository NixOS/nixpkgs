{
  buildDunePackage,
  tls,
  lwt,
  mirage-crypto-rng,
}:

buildDunePackage {
  pname = "tls-lwt";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";

  doCheck = true;

  propagatedBuildInputs = [
    lwt
    mirage-crypto-rng
    tls
  ];
}
