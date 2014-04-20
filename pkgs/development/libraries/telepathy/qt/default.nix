{ stdenv, fetchurl, cmake, qt4, pkgconfig, python, libxslt, dbus_glib
, telepathy_farstream, telepathy_glib, pythonDBus }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.3";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "1yabyhsikw828ns7cf6hvzbxdxh53na1ck0q7qsav1lvlyz5gzy0";
  };

  nativeBuildInputs = [ cmake pkgconfig python libxslt ];
  propagatedBuildInputs = [ qt4 dbus_glib telepathy_farstream telepathy_glib pythonDBus ];
  patches = [ ./cmake-2.8.12.diff ./farstream-0.2.diff ];
  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';
}
