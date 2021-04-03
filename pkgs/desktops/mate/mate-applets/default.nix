{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, gnome3, glib, gtk3, gtksourceview3, libwnck3
, libgtop, libxml2, libnotify, polkit, upower, wirelesstools, mate, hicolor-icon-theme, wrapGAppsHook
, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-applets";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0h70i4x3bk017pgv4zn280682wm58vwdjm7kni91ni8rmblnnvyp";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtksourceview3
    gnome3.gucharmap
    libwnck3
    libgtop
    libxml2
    libnotify
    polkit
    upower
    wirelesstools
    mate.libmateweather
    mate.mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--enable-suid=no" ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Applets for use with the MATE panel";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
