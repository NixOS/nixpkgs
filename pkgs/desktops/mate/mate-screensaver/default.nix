{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus-glib, libXScrnSaver, libnotify, pam, systemd, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-screensaver-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1698608m6kf4dn91xdwy7l809yagz02h1k594smj75wvnhr7x4k9";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libXScrnSaver
    libnotify
    pam
    systemd
    mate.mate-desktop
    mate.mate-menus
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
