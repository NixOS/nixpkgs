{ stdenv, fetchurl, pkgconfig, intltool, dbus_glib, libcanberra_gtk3,
  libnotify, libwnck3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-notification-daemon-${version}";
  version = "1.18.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "102nmd6mnf1fwvw11ggdlgcblq612nd4aar3gdjzqn1fw37591i5";
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
