{ lib, stdenv, fetchurl, fetchpatch, pkg-config, intltool, dbus-glib, gtk2, libical, libnotify, tzdata
, popt, libxfce4ui, xfce4-panel, withPanelPlugin ? true, wrapGAppsHook, xfce }:

assert withPanelPlugin -> libxfce4ui != null && xfce4-panel != null;

let
  inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  pname = "orage";
  version = "4.12.1";

  src = fetchurl {
    url = "https://archive.xfce.org/src/apps/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0qlhvnl2m33vfxqlbkic2nmfpwyd4mq230jzhs48cg78392amy9w";
  };

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook ];

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
      url = "https://aur.archlinux.org/cgit/aur.git/plain/libical3.patch?h=orage-4.10";
      sha256 = "1l8s106mcidmbx2p8c2pi8v9ngbv2x3fsgv36j8qk8wyd4qd1jbf";
    })
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister "apps" pname;
  };

  meta = with lib; {
    description = "Simple calendar application with reminders";
    homepage = "https://git.xfce.org/archive/orage/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
