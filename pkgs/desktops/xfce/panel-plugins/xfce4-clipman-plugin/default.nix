{ lib
, mkXfceDerivation
, glib
, gtk3
, libX11
, libXtst
, libxfce4ui
, libxfce4util
, qrencode
, xfce4-panel
, xfconf
, wayland
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.5";
  sha256 = "sha256-aKcIwlNlaJEHgIq0S7+VG/os49+zRqkZXsQVse4B9oE=";

  buildInputs = [
    glib
    gtk3
    libX11
    libXtst
    libxfce4ui
    libxfce4util
    qrencode
    xfce4-panel
    xfconf
    wayland
  ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
