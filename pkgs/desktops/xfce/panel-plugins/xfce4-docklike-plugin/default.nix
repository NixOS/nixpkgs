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
  version = "0.4.2-unstable-2024-11-04";
  rev = "1154bf1c9f291d5699663910d5aac71bb3ab2227";
  sha256 = "sha256-uno3qNyuesK/hJMdAxHZS6XMysr7ySOgJ5ACXGcIWFs=";

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
