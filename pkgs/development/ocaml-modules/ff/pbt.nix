{ lib, fetchFromGitLab, buildDunePackage, zarith, ff-sig, alcotest }:

buildDunePackage {
  pname = "ff-pbt";
  inherit (ff-sig) version src doCheck useDune2;

  minimalOCamlVersion = "4.08";

  checkInputs = [
    alcotest
  ];

  propagatedBuildInputs = [
    zarith
    ff-sig
  ];

  meta = ff-sig.meta // {
    description = "Property based testing library for finite fields over the package ff-sig";
  };
}
