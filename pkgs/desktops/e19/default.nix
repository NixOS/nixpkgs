{ callPackage, pkgs }:
let
  openjpeg_1 = with pkgs; lib.overrideDerivation openjpeg (oldAttrs: rec {
         name = "openjpeg-1.5.2";
         src = fetchurl {
           url = "mirror://sourceforge/openjpeg.mirror/${name}.tar.gz";
           sha1 = "lahbqvjpsfdxsrm0wsy3pdrp3pzrjvj9";
         };
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
