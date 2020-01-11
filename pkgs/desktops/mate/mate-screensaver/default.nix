{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus-glib, libXScrnSaver, libnotify, pam, systemd, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-screensaver";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1y8828g4bys8y4r5y478z6i7dgdqm2wkymi5fq75vxx4lzq919cb";
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

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
