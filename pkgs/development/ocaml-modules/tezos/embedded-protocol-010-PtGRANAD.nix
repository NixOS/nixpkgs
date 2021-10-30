{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-010-PtGRANAD
, tezos-protocol-updater
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-embedded-protocol-010-PtGRANAD";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/proto_010_PtGRANAD/lib_protocol";

  preBuild = tezos-protocol-010-PtGRANAD.preBuild;

  propagatedBuildInputs = [
    tezos-protocol-010-PtGRANAD
    tezos-protocol-updater
  ];

  buildInputs = [
    tezos-protocol-compiler
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition, embedded in `tezos-node`";
  };
}
