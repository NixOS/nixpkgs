{ lib
, mkXfceDerivation
, gobject-introspection
, wayland-scanner
, glib
, gtk3
, libdisplay-info
, libwnck
, libX11
, libXrandr
, wayland
, wayland-protocols
, wlr-protocols
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.20.2";

  sha256 = "sha256-Xw1hs854K5dZCAYoBMoqJzdSxPRFUYqEpWxg4DLSK5Q=";

  nativeBuildInputs = [
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    glib
    gtk3
    libdisplay-info
    libwnck
    libX11
    libXrandr
    wayland
    wayland-protocols
    wlr-protocols
  ];

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.xfce.members;
  };
}
