{ mkXfceDerivation, exo, garcon, gtk3, glib
, libnotify, libxfce4ui, libxfce4util, libxklavier
, upower, xfconf, xf86inputlibinput }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.16.0";

  sha256 = "0iha3jm7vmgk6hq7z4l2r7w9qm5jraka0z580i8i83704kfx9g0y";

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

  meta = {
    description = "Settings manager for Xfce";
  };
}
