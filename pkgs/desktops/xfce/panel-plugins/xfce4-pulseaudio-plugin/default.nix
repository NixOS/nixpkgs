{ lib
, mkXfceDerivation
, exo
, gtk3
, libcanberra
, libpulseaudio
, libnotify
, libxfce4ui
, libxfce4util
, libxfce4windowing
, xfce4-panel
, xfconf
, keybinder3
, glib
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-pulseaudio-plugin";
  version = "0.4.9";
  sha256 = "sha256-bJp4HicAFPuRATDHus0DfJFy1c6gw6Tkpd2UN7SXqsI=";

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
    libxfce4windowing
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Adjust the audio volume of the PulseAudio sound system";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
