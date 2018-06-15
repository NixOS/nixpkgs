{ stdenv, fetchurl, pkgconfig, intltool, dbus-glib, libcanberra-gtk3,
  libnotify, libwnck3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-notification-daemon-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0dq457npzid20yfwigdh8gfqgf5wv8p6jhbxfnzybam9xidlqc5f";
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
