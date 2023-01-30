{ lib
, buildDunePackage
, hacl-star
, bls12-381
, tezos-bls12-381-polynomial
, data-encoding
, hex
, stdint
, ff
, mec
, alcotest
, qcheck-alcotest
, bisect_ppx
}:

buildDunePackage rec {
  pname = "tezos-plompiler";
  duneVersion = "3";

  inherit (tezos-bls12-381-polynomial) version src;

  propagatedBuildInputs = [
    hacl-star
    bls12-381
    tezos-bls12-381-polynomial
    data-encoding
    hex
    stdint
    ff
    mec
  ];

  nativeCheckInputs = [ alcotest qcheck-alcotest bisect_ppx ];

  doCheck = false; # circular deps

  meta = tezos-bls12-381-polynomial.meta // {
    description = "Library to write arithmetic circuits for Plonk";
  };
}
