{ lib
, mkXfceDerivation
, automakeAddFlags
, exo
, gtk3
, libcanberra
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
  version = "0.4.8";
  sha256 = "sha256-7vcjARm0O+/hVNFzOpxcgAnqD+wRNg5/eqXLcq4t/iU=";

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
    libcanberra
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
