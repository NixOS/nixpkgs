{ lib
, buildDunePackage
, tezos-stdlib
, tezos-crypto
, tezos-hacl-glue-unix
, tezos-micheline
, tezos-test-helpers
, ptime
, ipaddr
, bls12-381-unix
}:

buildDunePackage {
  pname = "tezos-base";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_base";

  propagatedBuildInputs = [
    tezos-crypto
    tezos-micheline
    tezos-hacl-glue-unix
    bls12-381-unix
    ptime
    ipaddr
  ];

  checkInputs = [
    # tezos-test-helpers
  ];

  # circular dependency if we add this
  doCheck = false;

  meta = tezos-stdlib.meta // {
    description = "Tezos: meta-package and pervasive type definitions for Tezos";
  };
}
