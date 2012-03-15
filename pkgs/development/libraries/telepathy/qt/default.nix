{ stdenv, fetchurl, cmake, qt4, pkgconfig, python, libxslt, dbus_glib
, telepathy_farsight, telepathy_glib }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "0v3hnvzm3k2z99rc1znxgriqvf1n7wyjdzzsld0czhbmrz9fhang";
  };

  buildNativeInputs = [ cmake pkgconfig python libxslt ];
  propagatedBuildInputs = [ qt4 dbus_glib telepathy_farsight telepathy_glib ];

  patches = [ ./missing-include.patch ];

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags farsight2-0.10 dbus-glib-1`"
    '';
}
