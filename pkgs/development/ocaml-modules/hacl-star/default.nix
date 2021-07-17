{ lib, buildDunePackage, hacl-star-raw, zarith, cppo }:

buildDunePackage {
  pname = "hacl-star";

  inherit (hacl-star-raw) version sourceRoot src meta doCheck;

  useDune2 = true;

  propagatedBuildInputs = [
    hacl-star-raw
    zarith
    cppo
  ];
}
