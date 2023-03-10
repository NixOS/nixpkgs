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
  version = "4.18.1";

  sha256 = "sha256-Uy5dObnMV+fpt8RdyFOsYVPN8Dyx1zzOu0pDak01ipQ=";

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
