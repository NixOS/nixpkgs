{ lib, buildDunePackage, hacl-star-raw, zarith, cppo }:

buildDunePackage {
  pname = "hacl-star";

  inherit (hacl-star-raw) version src meta doCheck minimumOcamlVersion;

  useDune2 = true;

  propagatedBuildInputs = [
    hacl-star-raw
    zarith
  ];

  buildInputs = [
    cppo
  ];
}
