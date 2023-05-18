{ lib
, mkXfceDerivation
, automakeAddFlags
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
  version = "0.4.6";
  sha256 = "sha256-P1ln0cBskRAPsIygKAZeQLvt51xgMOnm0WZoR5sRvsM=";

  nativeBuildInputs = [
    automakeAddFlags
  ];

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

  meta = with lib; {
    description = "Adjust the audio volume of the PulseAudio sound system";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
