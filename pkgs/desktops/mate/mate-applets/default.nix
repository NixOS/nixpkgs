{ stdenv, fetchurl, pkgconfig, intltool, itstool, gnome3, libwnck3, libgtop, libxml2, libnotify, dbus-glib, polkit, upower, wirelesstools, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-applets-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1a119g49sr7jrd8i32bw7sn2qlsg3sdiwqdb2v36bm2999j261wc";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.gtk
    gnome3.gtksourceview
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
  
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  meta = with stdenv.lib; {
    description = "Applets for use with the MATE panel";
    homepage = http://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
