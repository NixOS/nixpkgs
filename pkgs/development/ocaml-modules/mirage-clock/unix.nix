{ buildDunePackage, mirage-clock, dune-configurator }:

buildDunePackage {
  pname = "mirage-clock-unix";

<<<<<<< HEAD
  inherit (mirage-clock) version src;
=======
  inherit (mirage-clock) version useDune2 src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ mirage-clock ];

  meta = mirage-clock.meta // {
    description = "Unix-based implementation for the MirageOS Clock interface";
  };
}
