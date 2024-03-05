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
  version = "4.18.4";

  sha256 = "sha256-f6ldTmTSvfRjn6j/LKIoFI3cbYZFtNdnAq3dQewc948=";

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
