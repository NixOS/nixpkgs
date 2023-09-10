{ mkXfceDerivation
, lib
, cmake
, accountsservice
, exo
, garcon
, gettext
, glib
, gtk-layer-shell
, gtk3
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.8.0";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-5ojcIOVIa9WKL2e6iZwRgrAINSM8750zciCwpn9vzJU=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    accountsservice
    exo
    garcon
    gettext
    glib
    gtk-layer-shell
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Alternate application launcher for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
