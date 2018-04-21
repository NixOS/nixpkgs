{ mkXfceDerivation, automakeAddFlags, dbus_glib, exo, garcon, gtk3
, libnotify ? null, libxfce4ui, libxfce4util, libxklavier ? null
, upower ? null, xfconf, xf86inputlibinput ? null }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.13.1";

  sha256 = "010vcgy3qiqykk174jhf50a8q3x4a5qq2lf6b0wcbyzv7aikydrw";

  postPatch = ''
    automakeAddFlags xfce4-settings-editor/Makefile.am xfce4_settings_editor_CFLAGS DBUS_GLIB_CFLAGS
    for f in $(find . -name \*.c); do
      substituteInPlace $f --replace \"libinput-properties.h\" '<xorg/libinput-properties.h>'
    done
  '';

  nativeBuildInputs = [ automakeAddFlags ];

  buildInputs = [
    dbus_glib
    exo
    garcon
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    libxklavier
    upower
    xfconf
    xf86inputlibinput
  ];

  configureFlags = [
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
  ];
}
