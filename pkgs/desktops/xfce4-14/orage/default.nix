{ lib, fetchpatch, mkXfceDerivation, dbus-glib, gtk2, libical, libnotify, tzdata
, popt, libxfce4ui, xfce4-panel, withPanelPlugin ? true }:

assert withPanelPlugin -> libxfce4ui != null && xfce4-panel != null;

let
  inherit (lib) optionals;
in

mkXfceDerivation rec {
  category = "apps";
  pname = "orage";
  version = "4.12.1";

  sha256 = "04z6y1vfaz1im1zq1zr7cf8pjibjhj9zkyanbp7vn30q520yxa0m";
  buildInputs = [ dbus-glib gtk2 libical libnotify popt ]
    ++ optionals withPanelPlugin [ libxfce4ui xfce4-panel ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace tz_convert/tz_convert.c --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postConfigure = "rm -rf libical"; # ensure pkgs.libical is used instead of one included in the orage sources

  patches = [
    # Fix build with libical 3.0
    (fetchpatch {
      name = "fix-libical3.patch";
      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/libical3.patch?h=packages/orage&id=7b1b06c42dda034d538977b9f3550b28e370057f;
      sha256 = "1l8s106mcidmbx2p8c2pi8v9ngbv2x3fsgv36j8qk8wyd4qd1jbf";
    })
  ];
}
