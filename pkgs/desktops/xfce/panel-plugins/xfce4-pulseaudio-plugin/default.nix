{ mkXfceDerivation, automakeAddFlags, dbus-glib, dbus, gtk3, libpulseaudio
, libnotify, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-pulseaudio-plugin";
  version = "0.4.1";
  sha256 = "1c8krpg3l6ki00ldd9hifc4bddysdm0w3x5w43fkr31j0zrscvfp";

  nativeBuildInputs = [ automakeAddFlags ];

  NIX_CFLAGS_COMPILE = "-I${dbus-glib.dev}/include/dbus-1.0 -I${dbus.dev}/include/dbus-1.0";

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
  '';

  buildInputs = [ gtk3 libnotify libpulseaudio libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Adjust the audio volume of the PulseAudio sound system";
  };
}
