{ lib, mkXfceDerivation, dbus_glib ? null, gtk2, libical, libnotify ? null
, popt ? null, libxfce4ui ? null, xfce4-panel ? null, withPanelPlugin ? true }:

assert withPanelPlugin -> libxfce4ui != null && xfce4-panel != null;

let
  inherit (lib) optionals;
in

mkXfceDerivation rec {
  category = "apps";
  pname = "orage";
  version = "4.12.1";

  sha256 = "04z6y1vfaz1im1zq1zr7cf8pjibjhj9zkyanbp7vn30q520yxa0m";
  buildInputs = [ dbus_glib gtk2 libical libnotify popt ]
    ++ optionals withPanelPlugin [ libxfce4ui xfce4-panel ];
}
