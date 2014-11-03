{ stdenv, fetchurl, cmake, qt4, pkgconfig, python, libxslt, dbus_glib, dbus_daemon
, telepathy_farstream, telepathy_glib, pythonDBus }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.5";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "13lwh23ad9bg7hx1mj4xjc2lb8nlaaw8hbrmx5gg8nz5xxc4hiwk";
  };

  nativeBuildInputs = [ cmake pkgconfig python libxslt ];
  propagatedBuildInputs = [ qt4 dbus_glib telepathy_farstream telepathy_glib pythonDBus ];

  buildInputs = stdenv.lib.optional doCheck dbus_daemon;

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';

  enableParallelBuilding = true;
  doCheck = false; # giving up for now

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
