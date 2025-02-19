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

buildDunePackage rec {
  pname = "mirage-crypto-rng";

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
