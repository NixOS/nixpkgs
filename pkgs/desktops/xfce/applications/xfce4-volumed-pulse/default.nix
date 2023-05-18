{ lib, mkXfceDerivation, gtk3, libnotify, libpulseaudio, keybinder3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-volumed-pulse";
  version = "0.2.3";

  sha256 = "sha256-EgmTk19p9OBmz3rWQB0LoPhhoDm4u1V6/vvgitOzUuc=";

  # https://gitlab.xfce.org/apps/xfce4-volumed-pulse/-/merge_requests/3
  postPatch = ''
    substituteInPlace configure.ac.in \
      --replace "2.16" "2.26"
  '';

  buildInputs = [ gtk3 libnotify libpulseaudio keybinder3 xfconf ];

  meta = with lib; {
    description = "A volume keys control daemon for Xfce using pulseaudio";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ] ++ teams.xfce.members;
  };
}
