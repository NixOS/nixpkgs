{ lib, mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.16.1";

  sha256 = "sha256-JecuD0DJASHaxL6gwmL3hcmAEA7sVIyaM0ushrdq4/Y=";

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
