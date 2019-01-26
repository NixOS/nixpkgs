{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, libxslt, libatasmart, libnotify, dbus-glib, lm_sensors, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-sensors-applet-${version}";
  version = "1.20.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0s98qy3jkri9zh5xqffprqd00cqspaq9av0mcrcakjkl8wyfh2g6";
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
