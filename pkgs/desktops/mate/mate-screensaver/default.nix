{ stdenv, fetchurl, pkgconfig, gettext, gtk3, dbus-glib, libXScrnSaver, libnotify, libxml2, pam, systemd, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-screensaver";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0gpw6x9d0b77f14vjl7ghq5dya1mwcnvmgigg00manfwlksr5zby";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    libxml2 # provides xmllint
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
