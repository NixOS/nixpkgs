{
  buildDunePackage,
  tls,
  async,
  cstruct-async,
  core,
  mirage-crypto-rng,
}:

buildDunePackage {
  pname = "tls-async";

  inherit (tls) src version;

  minimalOCamlVersion = "4.14";

  doCheck = true;

  propagatedBuildInputs = [
    async
    core
    cstruct-async
    mirage-crypto-rng
    tls
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, Async layer";
  };
}
