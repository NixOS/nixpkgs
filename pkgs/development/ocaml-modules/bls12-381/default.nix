{ lib, buildDunePackage, bls12-381-gen, ff-sig, zarith, ctypes, alcotest }:

buildDunePackage rec {
  pname = "bls12-381";

  inherit (bls12-381-gen) version src useDune2 doCheck;

  minimalOCamlVersion = "4.08";
  propagatedBuildInputs = [
    ff-sig
    zarith
    ctypes
    bls12-381-gen
  ];

  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
