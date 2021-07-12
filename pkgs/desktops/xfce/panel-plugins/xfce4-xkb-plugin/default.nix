{ lib
, mkXfceDerivation
, gtk3
, librsvg
, libwnck
, libxklavier
, garcon
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-xkb-plugin";
  version = "0.8.2";
  rev-prefix = "";
  sha256 = "sha256-xmCoNMxykeaThYEJo6BcbraFo9CruFZL6YPjovzb6hg=";

  buildInputs = [
    garcon
    gtk3
    librsvg
    libxfce4ui
    libxfce4util
    libxklavier
    libwnck
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Allows you to setup and use multiple keyboard layouts";
    maintainers = [ ];
  };
}
