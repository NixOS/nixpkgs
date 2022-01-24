{ lib
, ocaml
, buildDunePackage
, bls12-381
, bls12-381-legacy
, tezos-stdlib
, tezos-base
, tezos-sapling
, tezos-context
, tezos-protocol-environment-sigs
, tezos-protocol-environment-structs
, tezos-test-helpers
, zarith
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-protocol-environment";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_environment";

  propagatedBuildInputs = [
    bls12-381
    bls12-381-legacy
    tezos-sapling
    tezos-base
    tezos-context
    tezos-protocol-environment-sigs
    tezos-protocol-environment-structs
    zarith # this might break, since they actually want 1.11
  ];

  checkInputs = [
    alcotest-lwt
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: custom economic-protocols environment implementation for `tezos-client` and testing";
  };
}
