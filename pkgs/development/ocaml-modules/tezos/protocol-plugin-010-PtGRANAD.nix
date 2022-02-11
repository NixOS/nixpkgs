{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-010-PtGRANAD
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-protocol-plugin-010-PtGRANAD";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/proto_010_PtGRANAD/lib_plugin";

  buildInputs = [
    tezos-protocol-010-PtGRANAD
    tezos-protocol-environment
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol plugin registerer";
  };
}
