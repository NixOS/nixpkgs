{ lib
, buildDunePackage
, tezos-stdlib
, tezos-clic
, tezos-rpc
, bls12-381
, hacl-star
, secp256k1-internal
, uecc
, ringo
, ff
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-crypto";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-clic
    tezos-rpc
    bls12-381
    hacl-star
    secp256k1-internal
    uecc
    ringo
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: library with all the cryptographic primitives used by Tezos";
  };
}
