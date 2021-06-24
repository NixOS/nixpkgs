{ lib, buildDunePackage
, mirage-crypto, mirage-crypto-rng
, dune-configurator, async, logs
}:

buildDunePackage {
  pname = "mirage-crypto-rng-async";

  inherit (mirage-crypto) useDune2 version minimumOCamlVersion src;

  nativeBuildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    async
    logs
    mirage-crypto
    mirage-crypto-rng
  ];

  meta = mirage-crypto.meta // {
    description = "Feed the entropy source in an Async-friendly way";
  };
}
