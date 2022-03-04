{ lib
, buildDunePackage
, mirage-clock
}:

buildDunePackage {
  pname = "mirage-clock-freestanding";

  inherit (mirage-clock)
    version
    src
    minimumOCamlVersion
    ;

  propagatedBuildInputs = [
    mirage-clock
  ];

  meta = mirage-clock.meta // {
    description = "Paravirtual implementation of the MirageOS Clock interface";
  };
}
