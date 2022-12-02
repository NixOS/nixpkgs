{ lib, buildDunePackage, ff-pbt, ff-sig, zarith, alcotest }:

buildDunePackage rec {
  pname = "ff";
  inherit (ff-sig) version src;

  propagatedBuildInputs = [
    ff-sig
    zarith
  ];

  checkInputs = [
    alcotest
    ff-pbt
  ];

  doCheck = true;

  meta = ff-sig.meta // {
    description = "OCaml implementation of Finite Field operations";
  };
}
