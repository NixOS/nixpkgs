{ stdenv, fetchurl, intltool, pkgconfig, glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gnome-menus-${version}";
  version = "3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-menus/3.10/${name}.tar.xz";
    sha256 = "0wcacs1vk3pld8wvrwq7fdrm11i56nrajkrp6j1da6jc4yx0m5a6";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  buildInputs = [ intltool pkgconfig glib gobjectIntrospection ];

  meta = {
    homepage = "http://www.gnome.org";
    description = "Gnome menu specification";

    platforms = stdenv.lib.platforms.linux;
  };
}
