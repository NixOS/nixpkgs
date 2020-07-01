{ mkXfceDerivation
, automakeAddFlags
, dbus-glib
, dbus
, exo
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
  version = "0.4.3";
  sha256 = "1rfw2w8gl95iawiy57qlvz958dqjc8bmxnc3dma4rqzm6g46jkgq";

  nativeBuildInputs = [
    automakeAddFlags
  ];

  NIX_CFLAGS_COMPILE = "-I${dbus-glib.dev}/include/dbus-1.0 -I${dbus.dev}/include/dbus-1.0";

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
  '';

  buildInputs = [
    exo
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
