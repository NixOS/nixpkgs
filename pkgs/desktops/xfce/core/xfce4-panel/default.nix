{ lib
, mkXfceDerivation
, cairo
, exo
, garcon
, gobject-introspection
, gtk-layer-shell
, gtk3
, libdbusmenu-gtk3
, libwnck
, libxfce4ui
, libxfce4util
, libxfce4windowing
, tzdata
, vala
, wayland
, xfconf
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.20.3";

  sha256 = "sha256-tLWjU0M7tuE+qqDwaE1CtnOjDiPWno8Mf7hhxYxbvjo=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  buildInputs = [
    cairo
    exo
    garcon
    gtk-layer-shell
    libdbusmenu-gtk3
    libxfce4ui
    libxfce4windowing
    libwnck
    tzdata
    wayland
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  postPatch = ''
    substituteInPlace plugins/clock/clock.c \
       --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  meta = with lib; {
    description = "Panel for the Xfce desktop environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
