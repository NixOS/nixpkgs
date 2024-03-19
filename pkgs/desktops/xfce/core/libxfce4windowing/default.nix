{ lib, mkXfceDerivation, gobject-introspection, glib, gtk3, libwnck, wayland }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.19.2";

  sha256 = "sha256-mXxxyfwZB/AJFVVGFAAXLqC5p7pZAeqmhljQym55hyM=";

  nativeBuildInputs = [ gobject-introspection ];
  buildInputs = [ glib gtk3 libwnck wayland ];

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.xfce.members ++ [ lib.maintainers.federicoschonborn ];
  };
}
