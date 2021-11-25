{ lib
, buildDunePackage
, rustc
, cargo
, dune-configurator
, bls12-381
, bls12-381-gen
, ff-pbt
, ff-sig
, zarith
, ctypes
, tezos-rust-libs
, alcotest
}:

buildDunePackage {
  pname = "bls12-381-unix";

  inherit (bls12-381-gen) version src useDune2 doCheck;

  checkInputs = [
    alcotest
    ff-pbt
  ];

  buildInputs = [
    rustc
    cargo
    dune-configurator
  ];

  propagatedBuildInputs = [
    ff-sig
    zarith
    ctypes
    bls12-381-gen
    bls12-381
    tezos-rust-libs
  ];

  # This is a hack to work around the hack used in the dune files
  OPAM_SWITCH_PREFIX = "${tezos-rust-libs}";

  meta = {
    description = "UNIX version of BLS12-381 primitives implementing the virtual package bls12-381";
    license = lib.licenses.mit;
  };
}
