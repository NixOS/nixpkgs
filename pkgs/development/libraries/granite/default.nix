{ stdenv, fetchurl, perl, cmake, vala_0_23, pkgconfig, gobjectIntrospection, glib, gtk3, gnome3, gettext }:

stdenv.mkDerivation rec {
  majorVersion = "0.3";
  minorVersion = "0";
  name = "granite-${majorVersion}.${minorVersion}";
  src = fetchurl {
    url = "https://code.launchpad.net/granite/${majorVersion}/${majorVersion}/+download/${name}.tar.gz";
    sha256 = "1laa109dz7kbd8zxddqw2p1b67yzva7cc5h3smqkj8a9jzbhv5fz";
  };
  cmakeFlags = "-DINTROSPECTION_GIRDIR=share/gir-1.0/ -DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0";
  buildInputs = [perl cmake vala_0_23 pkgconfig gobjectIntrospection glib gtk3 gnome3.libgee gettext];
  meta = {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = "An extension to GTK+ that provides several useful widgets and classes to ease application development. Designed for elementary OS.";
    homepage = https://launchpad.net/granite;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
