{ lib, buildDunePackage, tls, async, cstruct-async, core, cstruct, mirage-crypto-rng-async }:

buildDunePackage rec {
  pname = "tls-async";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";
  duneVersion = "3";

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
