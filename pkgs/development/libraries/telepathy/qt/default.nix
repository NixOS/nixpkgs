{ stdenv, fetchurl, cmake, qt4, pkgconfig, python, libxslt, dbus_glib, dbus_daemon
, telepathy_farstream, telepathy_glib, pythonDBus }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.4";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "1wk13rwpas1crj19xsbgl1c4qzri616xxa1hyhnykv4nkwxdpcgi";
  };

  patches = [ ./farstream-0.2.diff ];

  nativeBuildInputs = [ cmake pkgconfig python libxslt ];
  propagatedBuildInputs = [ qt4 dbus_glib telepathy_farstream telepathy_glib pythonDBus ];

  buildInputs = stdenv.lib.optional doCheck dbus_daemon;

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';

  enableParallelBuilding = true;
  doCheck = false; # giving up for now
}
