{ lib, buildDunePackage, tls, async, cstruct-async, core, cstruct, mirage-crypto-rng-async }:

buildDunePackage rec {
  pname = "tls-async";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.13";

  patches = [
    # Remove when TLS gets updated to v0.17.1.
    ./janestreet-0.16.patch
  ];

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
