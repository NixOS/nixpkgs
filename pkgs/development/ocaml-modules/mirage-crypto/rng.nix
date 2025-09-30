{
  buildDunePackage,
  mirage-crypto,
  ohex,
  ounit2,
  randomconv,
  dune-configurator,
  digestif,
  duration,
  logs,
}:

buildDunePackage {
  pname = "mirage-crypto-rng";

  minimalOCamlVersion = "4.14";

  inherit (mirage-crypto) version src;

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
    randomconv
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    digestif
    mirage-crypto
    duration
    logs
  ];

  meta = mirage-crypto.meta // {
    description = "Cryptographically secure PRNG";
  };
}
