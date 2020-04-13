{ mkXfceDerivation, automakeAddFlags, exo, garcon, gtk3, glib
, libnotify, libxfce4ui, libxfce4util, libxklavier
, upower, xfconf, xf86inputlibinput }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.14.0";

  sha256 = "13gmxd4sfgd6wky7s03bar58w9vl4i6jv2wncd6iajww791y5akn";

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
