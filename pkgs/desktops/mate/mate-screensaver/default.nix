{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus-glib, libXScrnSaver, libnotify, pam, systemd, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-screensaver-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "17fxyccsc410wbyxmds1sm7gjqbj6z46x5cjk1791hfzf0sh82sy";
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

  makeFlags = "DBUS_SESSION_SERVICE_DIR=$(out)/etc";

  meta = with stdenv.lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
