{
  lib,
  buildDunePackage,
  mirage-crypto,
  mirage-crypto-rng,
  dune-configurator,
  async,
  logs,
}:

buildDunePackage {
  pname = "mirage-crypto-rng-async";

  inherit (mirage-crypto) version src;

  duneVersion = "3";

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    async
    logs
    mirage-crypto
    mirage-crypto-rng
  ];

  strictDeps = true;

  meta = mirage-crypto.meta // {
    description = "Feed the entropy source in an Async-friendly way";
  };
}
