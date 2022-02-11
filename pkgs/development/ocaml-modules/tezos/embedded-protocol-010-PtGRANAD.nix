{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-010-PtGRANAD
, tezos-protocol-updater
}:

buildDunePackage {
  pname = "tezos-embedded-protocol-010-PtGRANAD";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-protocol-010-PtGRANAD
    tezos-protocol-updater
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition, embedded in `tezos-node`";
  };
}
