{
  buildDunePackage,
  mirage-crypto,
  mirage-crypto-rng,
  dune-configurator,
  eio,
  eio_main,
  ohex,
}:

buildDunePackage rec {
  pname = "mirage-crypto-rng-eio";

  inherit (mirage-crypto) version src;

  doCheck = true;
  checkInputs = [
    eio_main
    ohex
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-rng
    eio
  ];

  meta = mirage-crypto-rng.meta;
}
