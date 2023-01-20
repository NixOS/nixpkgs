{ lib, buildDunePackage, mimic, happy-eyeballs-mirage }:

buildDunePackage {
  pname = "mimic-happy-eyeballs";

  inherit (mimic) src version;

  minimalOCamlVersion = "4.08";

  strictDeps = true;

  buildInputs = [
    mimic
    happy-eyeballs-mirage
  ];
  doCheck = false;

  meta = {
    description = "A happy-eyeballs integration into mimic";
    maintainers = [ lib.maintainers.ulrikstrid ];
    inherit (mimic.meta) license homepage;
  };
}
