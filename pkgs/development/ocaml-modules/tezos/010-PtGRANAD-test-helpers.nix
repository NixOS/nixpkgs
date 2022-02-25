{ lib
, buildDunePackage
, tezos-stdlib
, tezos-stdlib-unix
, tezos-base
, tezos-shell-services
, tezos-protocol-environment
, tezos-010-PtGRANAD
, tezos-client-010-PtGRANAD
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-010-PtGRANAD-test-helpers";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/proto_010_PtGRANAD/lib_protocol/test/helpers";

  propagatedBuildInputs = [
    tezos-base
    tezos-stdlib-unix
    tezos-shell-services
    tezos-protocol-environment
    tezos-010-PtGRANAD.protocol
    tezos-010-PtGRANAD.protocol-parameters
    tezos-client-010-PtGRANAD
    alcotest-lwt
  ];

  checkInputs = [
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol testing framework";
  };
}
