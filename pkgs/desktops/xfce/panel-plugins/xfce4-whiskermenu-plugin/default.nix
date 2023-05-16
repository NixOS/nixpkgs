<<<<<<< HEAD
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
=======
{ lib, mkXfceDerivation, gettext, gtk3, glib, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
<<<<<<< HEAD
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
=======
  version = "2.7.3";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-F2mp3b1HBvI2lvwGzuE9QsqotLWgsP0NRyORrTV9FJs=";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gettext exo garcon gtk3 glib libxfce4ui libxfce4util xfce4-panel xfconf ];

  postPatch = ''
    substituteInPlace panel-plugin/xfce4-popup-whiskermenu.in \
      --replace gettext ${gettext}/bin/gettext
  '';

  postInstall = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4-panel.out}/bin/xfce4-panel
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Alternate application launcher for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
