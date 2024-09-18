{ lib
, mkXfceDerivation
, cairo
, glib
, gtk3
, libX11
, libxfce4ui
, libxfce4util
, xfce4-panel
, libwnck
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-docklike-plugin";
  version = "0.4.2";
  sha256 = "sha256-M/V8cnEU/nSEDjQ3k8fWiklF5OuNg3uzzJMHBSZBiLU=";

  buildInputs = [
    cairo
    glib
    gtk3
    libX11
    libxfce4ui
    libxfce4util
    xfce4-panel
    libwnck
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start";
    description = "Modern, minimalist taskbar for Xfce";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
