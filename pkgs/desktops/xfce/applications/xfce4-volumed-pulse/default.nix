{
  lib,
  mkXfceDerivation,
  gtk3,
  libnotify,
  libpulseaudio,
  keybinder3,
  xfconf,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-volumed-pulse";
  version = "0.2.5";

  sha256 = "sha256-A7PM4zHL4hkhsZjYEPuEiujP1ofP7V/QVqDNgGoGIm8=";

  buildInputs = [
    gtk3
    libnotify
    libpulseaudio
    keybinder3
    xfconf
  ];

  meta = with lib; {
    description = "Volume keys control daemon for Xfce using pulseaudio";
    mainProgram = "xfce4-volumed-pulse";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ] ++ teams.xfce.members;
  };
}
