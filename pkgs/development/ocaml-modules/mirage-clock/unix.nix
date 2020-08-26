{ buildDunePackage, mirage-clock }:

buildDunePackage {
  pname = "mirage-clock-unix";

  inherit (mirage-clock) version src;

  propagatedBuildInputs = [ mirage-clock ];

  meta = mirage-clock.meta // {
    description = "Unix-based implementation for the MirageOS Clock interface";
  };
}
