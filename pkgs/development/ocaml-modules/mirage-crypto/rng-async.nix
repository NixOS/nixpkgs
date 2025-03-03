{
  buildDunePackage,
  mirage-crypto,
  mirage-crypto-rng,
  dune-configurator,
  async,
  logs,
  ohex,
}:

buildDunePackage {
  pname = "mirage-crypto-rng-async";

  inherit (mirage-crypto) version src;

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    async
    logs
    mirage-crypto
    mirage-crypto-rng
  ];

  doCheck = true;
  checkInputs = [ ohex ];

  meta = mirage-crypto.meta // {
    description = "Feed the entropy source in an Async-friendly way";
  };
}
