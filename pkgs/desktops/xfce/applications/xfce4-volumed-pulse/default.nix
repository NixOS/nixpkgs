{ lib, mkXfceDerivation, gtk3, libnotify, libpulseaudio, keybinder3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-volumed-pulse";
  version = "0.2.4";

  sha256 = "sha256-NDIJRjKV5aoM2sLhZ6WmoynOc4yz55KpuiTJDMLMA5Y=";

  buildInputs = [ gtk3 libnotify libpulseaudio keybinder3 xfconf ];

  meta = with lib; {
    description = "A volume keys control daemon for Xfce using pulseaudio";
    mainProgram = "xfce4-volumed-pulse";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ] ++ teams.xfce.members;
  };
}
