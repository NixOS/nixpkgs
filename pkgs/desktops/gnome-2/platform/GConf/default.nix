{ stdenv, fetchurl, pkgconfig, dbus_glib, glib, ORBit2, libxml2
, polkit, intltool, dbus_libs, gtk }:

stdenv.mkDerivation {
  name = "GConf-2.32.4";

  src = fetchurl {
    url = mirror://gnome/sources/GConf/2.32/GConf-2.32.4.tar.xz;
    sha256 = "09ch709cb9fniwc4221xgkq0jf0x0lxs814sqig8p2dcll0llvzk";
  };

  buildInputs = [ ORBit2 dbus_libs dbus_glib libxml2 polkit gtk ];
  propagatedBuildInputs = [ glib ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = "--with-gtk=2.0";
}
