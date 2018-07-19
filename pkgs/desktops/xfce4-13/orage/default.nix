{ lib, fetchpatch, mkXfceDerivation, dbus_glib ? null, gtk2, libical, libnotify ? null
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

  patches = [
    # Fix build with libical 3.0
    (fetchpatch {
      name = "fix-libical3.patch";
      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/libical3.patch?h=packages/orage&id=7b1b06c42dda034d538977b9f3550b28e370057f;
      sha256 = "1l8s106mcidmbx2p8c2pi8v9ngbv2x3fsgv36j8qk8wyd4qd1jbf";
    })
  ];
}
