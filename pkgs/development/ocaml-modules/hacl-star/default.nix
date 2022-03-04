{ lib, buildDunePackage, hacl-star-raw, zarith, cppo }:

buildDunePackage {
  pname = "hacl-star";

  inherit (hacl-star-raw) version src meta doCheck minimalOCamlVersion;

  propagatedBuildInputs = [
    hacl-star-raw
    zarith
  ];

  nativeBuildInputs = [
    cppo
  ];

  strictDeps = true;
}
