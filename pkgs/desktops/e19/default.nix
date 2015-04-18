{ callPackage, pkgs }:
let
  openjpeg_1 = with pkgs; lib.overrideDerivation openjpeg (oldAttrs: {
         name = "openjpeg-1.5.1";
         src = fetchurl {
           url = "http://openjpeg.googlecode.com/files/openjpeg-1.5.1.tar.gz";
           sha1 = "1b0b74d1af4c297fd82806a9325bb544caf9bb8b";
         };
         #passthru = { incDir = "openjpeg-1.5.1"; };
     });
in
rec {
  #### CORE EFL
  efl = callPackage ./efl.nix { openjpeg=openjpeg_1; };
  evas = callPackage ./evas.nix { };
  emotion = callPackage ./emotion.nix { };
  elementary = callPackage ./elementary.nix { };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment.nix { };

  #### APPLICATIONS
  econnman = callPackage ./econnman.nix { };
  terminology = callPackage ./terminology.nix { };
  rage = callPackage ./rage.nix { };

}
