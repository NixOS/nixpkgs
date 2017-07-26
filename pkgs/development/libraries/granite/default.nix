{ stdenv, fetchurl, perl, cmake, vala, pkgconfig, gobjectIntrospection, glib, gtk3, gnome3, gettext }:

stdenv.mkDerivation rec {
  majorVersion = "0.4";
  minorVersion = "0.1";
  name = "granite-${majorVersion}.${minorVersion}";
  src = fetchurl {
    url = "https://launchpad.net/granite/${majorVersion}/${majorVersion}.${minorVersion}/+download/${name}.tar.xz";
    sha256 = "1pf4jkz3xyn1sqv70063im80ayb5kdsqwqwx11dc7vgypsl458cm";
  };
  cmakeFlags = "-DINTROSPECTION_GIRDIR=share/gir-1.0/ -DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0";
  buildInputs = [perl cmake vala pkgconfig gobjectIntrospection glib gtk3 gnome3.libgee gettext];
  meta = {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = "An extension to GTK+ that provides several useful widgets and classes to ease application development. Designed for elementary OS.";
    homepage = https://launchpad.net/granite;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
