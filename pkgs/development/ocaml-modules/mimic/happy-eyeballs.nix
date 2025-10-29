{
  lib,
  buildDunePackage,
  dns-client-mirage,
  mimic,
  happy-eyeballs-mirage,
}:

buildDunePackage {
  pname = "mimic-happy-eyeballs";

  inherit (mimic) src version;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    dns-client-mirage
    mimic
    happy-eyeballs-mirage
  ];
  doCheck = false;

  meta = {
    description = "Happy-eyeballs integration into mimic";
    maintainers = [ lib.maintainers.ulrikstrid ];
    inherit (mimic.meta) license homepage;
  };
}
