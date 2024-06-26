{
  lib,
  buildDunePackage,
  tls,
  async,
  cstruct-async,
  core,
  cstruct,
  mirage-crypto-rng-async,
}:

buildDunePackage rec {
  pname = "tls-async";

  inherit (tls) src version;

  minimalOCamlVersion = "4.14";

  doCheck = true;

  propagatedBuildInputs = [
    async
    core
    cstruct
    cstruct-async
    mirage-crypto-rng-async
    tls
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, Async layer";
  };
}
