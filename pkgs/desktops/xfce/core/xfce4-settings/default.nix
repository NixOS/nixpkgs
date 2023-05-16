{ lib
, mkXfceDerivation
, exo
, garcon
, gtk3
, glib
, libnotify
, libxfce4ui
, libxfce4util
, libxklavier
, upower
, xfconf
, xf86inputlibinput
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
<<<<<<< HEAD
  version = "4.18.3";

  sha256 = "sha256-QGh5th790qkvqchUfi+kOAJ9A1M+zEIzMxOM5eCGPEk=";
=======
  version = "4.18.2";

  sha256 = "sha256-u8xto4tP9fsaPaY6dzv4Bj/C6qvltT5wXJlV+TzP5uE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    for f in xfsettingsd/pointers.c dialogs/mouse-settings/main.c; do
      substituteInPlace $f --replace \"libinput-properties.h\" '<xorg/libinput-properties.h>'
    done
  '';

  buildInputs = [
    exo
    garcon
    glib
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    libxklavier
    upower
    xf86inputlibinput
    xfconf
  ];

  configureFlags = [
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
  ];

  meta = with lib; {
    description = "Settings manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
