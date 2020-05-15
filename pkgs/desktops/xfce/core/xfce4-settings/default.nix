{ mkXfceDerivation, automakeAddFlags, exo, garcon, gtk3, glib
, libnotify, libxfce4ui, libxfce4util, libxklavier
, upower, xfconf, xf86inputlibinput }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.14.3";

  sha256 = "1zzngdj7mp2r6rcs8gvda1218zlz5gpnc6gsp20z32l69psp3yld";

  postPatch = ''
    for f in $(find . -name \*.c); do
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
