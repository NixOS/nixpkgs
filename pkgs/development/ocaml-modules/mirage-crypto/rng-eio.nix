{
  buildDunePackage,
  mirage-crypto-rng,
  eio,
  eio_main,
  ohex,
}:

buildDunePackage {
  pname = "mirage-crypto-rng-eio";

  inherit (mirage-crypto-rng) version src;

  doCheck = true;
  checkInputs = [
    eio_main
    ohex
  ];

  propagatedBuildInputs = [
    mirage-crypto-rng
    eio
  ];

  meta = mirage-crypto-rng.meta;
}
