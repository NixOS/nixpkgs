{ stdenv, fetchurl, pkgconfig, intltool, dbus_glib, libcanberra_gtk3,
  libnotify, libwnck3, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-notification-daemon-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0rhhv99ipxy7l4fdgwvqp3g0c3d4njq0fhkag2vs1nwc6kx0h7sc";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    libcanberra_gtk3
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
