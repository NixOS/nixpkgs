{ mkXfceDerivation
, automakeAddFlags
, dbus-glib
, dbus
, gtk3
, libpulseaudio
, libnotify
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
, keybinder3
, glib
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-pulseaudio-plugin";
  version = "0.4.2";
  sha256 = "1s996mcniskq42vv7cb9i165pmrfp9c95p5f9rx14hqq8in9mvc5";

  nativeBuildInputs = [
    automakeAddFlags
  ];

  NIX_CFLAGS_COMPILE = "-I${dbus-glib.dev}/include/dbus-1.0 -I${dbus.dev}/include/dbus-1.0";

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
  '';

  buildInputs = [
    glib
    gtk3
    keybinder3
    libnotify
    libpulseaudio
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = {
    description = "Adjust the audio volume of the PulseAudio sound system";
  };
}
