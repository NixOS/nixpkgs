{ stdenv, fetchurl, intltool, pkgconfig, glib, gobjectIntrospection }:
let
  version = "3.10.1";
in
stdenv.mkDerivation {
  name = "gnome-menus-${version}";

    src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.10/gnome-menus-3.10.1.tar.xz";
    sha256 = "0wcacs1vk3pld8wvrwq7fdrm11i56nrajkrp6j1da6jc4yx0m5a6";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  preBuild = "patchShebangs ./scripts";

  buildInputs = [ intltool pkgconfig glib gobjectIntrospection ];

  meta = {
    homepage = "http://www.gnome.org";
    description = "Gnome menu specification";

    platforms = stdenv.lib.platforms.linux;
  };
}
