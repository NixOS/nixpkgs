{ lib
, mkXfceDerivation
<<<<<<< HEAD
, glib
, gtk3
, libxfce4ui
, libxfce4util
, pcre2
=======
, gtk3
, libxfce4ui
, pcre
, libxfce4util
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xfce4-panel
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-verve-plugin";
<<<<<<< HEAD
  version = "2.0.3";
  sha256 = "sha256-K335cs1vWKTNQjZlSUuhK8OmgTsKSzN87IZwS4RtvB8=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    pcre2
    xfce4-panel
  ];
=======
  version = "2.0.1";
  rev-prefix = "";
  sha256 = "sha256-YwUOSTZMoHsWWmi/ajQv/fX8a0IJoc3re3laVEmnX/M=";

  buildInputs = [ gtk3 libxfce4ui pcre libxfce4util xfce4-panel ];

  hardeningDisable = [ "format" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A command-line plugin";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
