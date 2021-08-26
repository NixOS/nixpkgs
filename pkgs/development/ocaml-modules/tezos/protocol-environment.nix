{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, tezos-sapling
, tezos-protocol-environment-sigs
, tezos-protocol-environment-structs
, zarith
, alcotest-lwt
, crowbar
}:

buildDunePackage {
  pname = "tezos-protocol-environment";
  inherit (tezos-stdlib) version src useDune2 doCheck preBuild;

  propagatedBuildInputs = [
    tezos-sapling
    tezos-base
    tezos-protocol-environment-sigs
    tezos-protocol-environment-structs
    zarith # this might break, since they actually want 1.11
  ];

  checkInputs = [
    alcotest-lwt
    crowbar
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: custom economic-protocols environment implementation for `tezos-client` and testing";
  };
}
