{
  lib,
  buildDunePackage,
  mimic,
  happy-eyeballs-mirage,
}:

buildDunePackage {
  pname = "mimic-happy-eyeballs";

  inherit (mimic) src version;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  strictDeps = true;

  propagatedBuildInputs = [
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
