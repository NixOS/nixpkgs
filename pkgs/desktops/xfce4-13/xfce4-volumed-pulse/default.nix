{ lib, mkXfceDerivation, gtk2, libnotify ? null, libpulseaudio, keybinder, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-volumed-pulse";
  version = "0.2.2";

  sha256 = "0ccb98b433lx5fgdqd3nqqppg4sldr5p1is6pnx85h9wyxx5svhp";

  buildInputs = [ gtk2 libnotify libpulseaudio keybinder xfconf ];

  meta = with lib; {
    license = licenses.gpl3Plus;
  };
}
