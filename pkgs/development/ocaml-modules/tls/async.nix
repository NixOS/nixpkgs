{ lib, buildDunePackage, tls, async, cstruct-async, core, cstruct, mirage-crypto-rng-async }:

buildDunePackage rec {
  pname = "tls-async";

  inherit (tls) src meta version;

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  doCheck = true;

  propagatedBuildInputs = [
    async
    core
    cstruct
    cstruct-async
    mirage-crypto-rng-async
    tls
  ];
}
