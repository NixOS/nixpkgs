{ lib
, buildDunePackage
, tezos-stdlib
, tezos-rpc
, tezos-clic
, tezos-hacl-glue
, tezos-hacl-glue-unix
, secp256k1-internal
, ringo
, bls12-381
, bls12-381-unix
, tezos-test-helpers
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-crypto";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_crypto";

  propagatedBuildInputs = [
    tezos-rpc
    tezos-clic
    tezos-hacl-glue
    tezos-hacl-glue-unix
    secp256k1-internal
    ringo
    bls12-381
    bls12-381-unix
  ];

  checkInputs = [
    tezos-test-helpers
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library with all the cryptographic primitives used by Tezos";
  };
}
