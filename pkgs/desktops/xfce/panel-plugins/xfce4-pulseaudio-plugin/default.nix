{ lib
, mkXfceDerivation
, automakeAddFlags
, exo
, gtk3
<<<<<<< HEAD
, libcanberra
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.4.7";
  sha256 = "sha256-9fumaX4M6NTXHM1gGa4wB/Uq+CZIUnvm9kC+pJNbWXU=";
=======
  version = "0.4.6";
  sha256 = "sha256-P1ln0cBskRAPsIygKAZeQLvt51xgMOnm0WZoR5sRvsM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    libcanberra
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
