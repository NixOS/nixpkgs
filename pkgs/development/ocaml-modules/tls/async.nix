{ lib, buildDunePackage, tls, async, cstruct-async, core, cstruct, mirage-crypto-rng-async, async_find }:

buildDunePackage rec {
  pname = "tls-async";

  inherit (tls) src meta version;

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  doCheck = true;

  propagatedBuildInputs = [
    async
    async_find
    core
    cstruct
    cstruct-async
    mirage-crypto-rng-async
    tls
  ];
}
