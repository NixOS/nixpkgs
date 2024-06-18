{ lib
, mkXfceDerivation
, gobject-introspection
, wayland-scanner
, glib
, gtk3
, libwnck
, libX11
, wayland
, wlr-protocols
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.19.3";

  sha256 = "sha256-nsobRyGeagUq1WHzYBq6vd9g5A65KEQC4cX+m7w0pqg=";

  nativeBuildInputs = [
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    glib
    gtk3
    libwnck
    libX11
    wayland
    wlr-protocols
  ];

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.xfce.members;
  };
}
