{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus_glib, libXScrnSaver, libnotify, pam, systemd, mate-desktop, mate-menus, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-screensaver-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "03za7ssww095i49braaq0di5ir9g6wxh1n5hfgy6b3w9nb0j1y2p";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus_glib
    libXScrnSaver
    libnotify
    pam
    systemd
    mate-desktop
    mate-menus
  ];

  configureFlags = "--without-console-kit";

  makeFlags = "DBUS_SESSION_SERVICE_DIR=$(out)/etc";

  meta = with stdenv.lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
