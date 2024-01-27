{ lib
, mkXfceDerivation
, glib
, gtk3
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.5";
  rev-prefix = "xfce4-battery-plugin-";
  odd-unstable = false;
  sha256 = "sha256-X5EGDZaPZdTxiLXyeLwnMx97P6wPy+H09hi9+OFYyY0=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Battery plugin for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
