{ stdenv, fetchurl, pkgconfig, intltool, dbus-glib, libcanberra-gtk3,
  libnotify, libwnck3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-notification-daemon-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0a60f67yjvlffrnviqgc64jz5l280f30h8br7wz2x415if5dmjyn";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    libcanberra-gtk3
    libnotify
    libwnck3
    gnome3.gtk
  ];

  meta = with stdenv.lib; {
    description = "Notification daemon for MATE";
    homepage = https://github.com/mate-desktop/mate-notification-daemon;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
