{ lib, mkXfceDerivation, gettext, gtk3, glib, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.7.2";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-yp8NpBVgqEv34qmDMKPdy53awgSLtYfeaw1JrxENFps=";

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

  meta = with lib; {
    description = "Alternate application launcher for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
