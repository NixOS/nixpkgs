{ stdenv, fetchurl, pkgconfig, intltool, itstool, gnome3, libwnck3, libgtop, libxml2, libnotify, dbus_glib, polkit, upower, wirelesstools, libmateweather, mate-panel, pythonPackages, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-applets-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "045cl62nnfsl14vnfydwqjssdakgdrahh5h0xiz5afmdcbq6cqgw";
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
    dbus_glib
    polkit
    upower
    wirelesstools
    libmateweather
    mate-panel
    pythonPackages.python
    pythonPackages.pygobject3
    hicolor_icon_theme
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
