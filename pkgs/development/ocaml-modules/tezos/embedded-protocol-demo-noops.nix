{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-demo-noops
, tezos-protocol-updater
}:

buildDunePackage {
  pname = "tezos-embedded-protocol-demo-noops";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-protocol-demo-noops
    tezos-protocol-updater
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: demo_noops (economic-protocol definition, embedded in `tezos-node`)";
  };
}
