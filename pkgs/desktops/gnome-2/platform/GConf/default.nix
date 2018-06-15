{ stdenv, fetchurl, pkgconfig, dbus-glib, glib, ORBit2, libxml2
, polkit, intltool, dbus_libs, gtk2 ? null, withGtk ? false }:

assert withGtk -> (gtk2 != null);

stdenv.mkDerivation {
  name = "gconf-2.32.4";

  src = fetchurl {
    url = mirror://gnome/sources/GConf/2.32/GConf-2.32.4.tar.xz;
    sha256 = "09ch709cb9fniwc4221xgkq0jf0x0lxs814sqig8p2dcll0llvzk";
  };

  outputs = [ "out" "dev" "man" ];

  buildInputs = [ ORBit2 dbus_libs dbus-glib libxml2 ]
    # polkit requires pam, which requires shadow.h, which is not available on
    # darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) polkit
    ++ stdenv.lib.optional withGtk gtk2;

  propagatedBuildInputs = [ glib ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = stdenv.lib.optional withGtk "--with-gtk=2.0"
    # fixes the "libgconfbackend-oldxml.so is not portable" error on darwin
    ++ stdenv.lib.optional stdenv.isDarwin [ "--enable-static" ];
}
