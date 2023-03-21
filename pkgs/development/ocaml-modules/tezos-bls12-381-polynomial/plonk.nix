{ lib
, buildDunePackage
, hacl-star
, bls12-381
, tezos-bls12-381-polynomial
, data-encoding
, tezos-plompiler
, alcotest
, qcheck-alcotest
, bisect_ppx
,
}:

buildDunePackage rec {
  pname = "tezos-plonk";
  duneVersion = "3";

  inherit (tezos-bls12-381-polynomial) version src;

  propagatedBuildInputs = [
    hacl-star
    bls12-381
    tezos-bls12-381-polynomial
    data-encoding
    tezos-plompiler
  ];

  checkInputs = [ alcotest qcheck-alcotest bisect_ppx ];

  doCheck = false; # broken

  meta = tezos-bls12-381-polynomial.meta // {
    description = "Plonk zero-knowledge proving system";
  };
}
