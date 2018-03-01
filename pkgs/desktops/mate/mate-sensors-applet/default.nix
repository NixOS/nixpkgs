{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, libxslt, libatasmart, libnotify, dbus-glib, lm_sensors, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-sensors-applet-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1yj8zr9w0a1h4bpd27w7ssg97vnrz7yr10jqhx67yyb900ccr3ik";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  # maybe add nvidia-settings later on
  buildInputs = [
    gtk3
    libxml2
    libxslt
    libatasmart
    libnotify
    dbus-glib
    lm_sensors
    mate.mate-panel
    hicolor-icon-theme
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mate-desktop/mate-sensors-applet;
    description = "MATE panel applet for hardware sensors";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
