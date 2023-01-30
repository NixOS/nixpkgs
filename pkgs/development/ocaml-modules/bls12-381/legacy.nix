{ lib
, buildDunePackage
, fetchFromGitLab
, bls12-381-gen
, ctypes
, ff-pbt
, ff-sig
, tezos-rust-libs
, zarith
, alcotest
}:

buildDunePackage rec {
  pname = "bls12-381-legacy";

  inherit (bls12-381-gen) version src useDune2 doCheck;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    bls12-381-gen
    ctypes
    ff-pbt
    ff-sig
    tezos-rust-libs
    zarith
  ];

  nativeCheckInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "UNIX version of BLS12-381 primitives, not implementating the virtual package bls12-381";
    license = lib.licenses.mit;
  };
}
