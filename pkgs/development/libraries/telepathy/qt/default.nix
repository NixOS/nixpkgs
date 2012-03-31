{ stdenv, fetchurl, cmake, qt4, pkgconfig, python, libxslt, dbus_glib
, telepathy_farstream, telepathy_glib }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.1";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "0rwyxjk6646r43mvsg01q7rfsah0ni05fa8gxzlx1zhj76db95yh";
  };

  buildNativeInputs = [ cmake pkgconfig python libxslt ];
  propagatedBuildInputs = [ qt4 dbus_glib telepathy_farstream telepathy_glib ];
  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';
}
