{ lib
, mkXfceDerivation
, wayland-scanner
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
, wlr-protocols
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.6";
  sha256 = "sha256-wdEoM4etco+s0+dULkBvWJZ3WBCW3Ph2bdY0E/l5VRc=";

  nativeBuildInputs = [
    wayland-scanner
  ];

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
    wlr-protocols
  ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
