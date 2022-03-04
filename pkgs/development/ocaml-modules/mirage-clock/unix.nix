{ buildDunePackage, mirage-clock, dune-configurator }:

buildDunePackage {
  pname = "mirage-clock-unix";

  inherit (mirage-clock) version src;

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ mirage-clock ];

  meta = mirage-clock.meta // {
    description = "Unix-based implementation for the MirageOS Clock interface";
  };
}
