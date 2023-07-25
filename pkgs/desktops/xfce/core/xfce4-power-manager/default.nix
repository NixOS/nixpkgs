{ lib
, mkXfceDerivation
, gtk3
, libnotify
, libxfce4ui
, libxfce4util
, upower
, xfconf
, xfce4-panel
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.18.2";

  sha256 = "sha256-1+DP5CACzzj96FyRTeCdVEFORnpzFT49d9Uk1iijbFs=";

  buildInputs = [
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    upower
    xfconf
    xfce4-panel
  ];

  meta = with lib; {
    description = "A power manager for the Xfce Desktop Environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
