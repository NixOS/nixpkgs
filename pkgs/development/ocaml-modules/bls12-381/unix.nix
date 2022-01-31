{ lib
, buildDunePackage
, bls12-381
, hex
, integers
, zarith
, alcotest
, bisect_ppx
, ff-pbt
}:

buildDunePackage {
  pname = "bls12-381-unix";

  inherit (bls12-381) version src useDune2 doCheck;

  propagatedBuildInputs = [
    bls12-381
    hex
    integers
    zarith
  ];

  checkInputs = [
    alcotest
    bisect_ppx
    ff-pbt
  ];

  meta = {
    description = "UNIX version of BLS12-381 primitives implementing the virtual package bls12-381";
    license = lib.licenses.mit;
  };
}
