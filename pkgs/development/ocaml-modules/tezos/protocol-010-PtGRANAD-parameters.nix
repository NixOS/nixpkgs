{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-010-PtGRANAD
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-protocol-010-PtGRANAD-parameters";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/proto_010_PtGRANAD/lib_parameters";

  propagatedBuildInputs = [
    tezos-protocol-010-PtGRANAD
    tezos-protocol-environment
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: parameters";
  };
}
