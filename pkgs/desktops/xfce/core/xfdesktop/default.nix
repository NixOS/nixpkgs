{ lib, mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.18.0";

  sha256 = "sha256-HZVu5UVLKDCWaUpw1SV8E0JLGRG946w4QLlA51rg/Bo=";

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
