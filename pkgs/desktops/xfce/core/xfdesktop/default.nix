{ lib, mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.18.1";

  sha256 = "sha256-33G7X5kA3MCNJ9Aq9ZCafP0Qm/46iUmLFB8clhKwDz8=";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libwnck
    xfconf
    libnotify
    garcon
    thunar
  ];

  meta = with lib; {
    description = "Xfce's desktop manager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
