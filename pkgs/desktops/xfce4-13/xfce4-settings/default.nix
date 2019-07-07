{ mkXfceDerivation, automakeAddFlags, exo, garcon, gtk3
, libnotify ? null, libxfce4ui, libxfce4util, libxklavier ? null
, upower ? null, xfconf, xf86inputlibinput ? null }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "0q6jh3fqw9n9agp018xiwidrld445irnli5jgwpszi9hc435dbpc";

  postPatch = ''
    automakeAddFlags xfce4-settings-editor/Makefile.am xfce4_settings_editor_CFLAGS DBUS_GLIB_CFLAGS
    for f in $(find . -name \*.c); do
      substituteInPlace $f --replace \"libinput-properties.h\" '<xorg/libinput-properties.h>'
    done
  '';

  nativeBuildInputs = [ automakeAddFlags ];

  buildInputs = [
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
