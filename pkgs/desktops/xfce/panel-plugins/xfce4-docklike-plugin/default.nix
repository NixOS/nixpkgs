{ lib
, mkXfceDerivation
, glib
, gtk3
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
, libwnck
, exo
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-docklike-plugin";
  version = "0.4.1";
  sha256 = "sha256-BKxd2TFEbRHeFy/dC2Wx5ppErsi7d2m7JicFCcZbjTo=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
    libwnck
    exo
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start";
    description = "A modern, minimalist taskbar for Xfce";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
