{ lib
, mkXfceDerivation
, cairo
, glib
, gtk3
, gtk-layer-shell
, libX11
, libxfce4ui
, libxfce4util
, xfce4-panel
, libxfce4windowing
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-docklike-plugin";
  version = "0.4.3";
  sha256 = "sha256-cQ9B/sIzp1sq3GXPMtbb8xrfFhWiBS+FDe7/qlWVPdA=";

  buildInputs = [
    cairo
    glib
    gtk3
    gtk-layer-shell
    libX11
    libxfce4ui
    libxfce4util
    xfce4-panel
    libxfce4windowing
  ];

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start";
    description = "Modern, minimalist taskbar for Xfce";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
