{ stdenv, fetchurl, pkgconfig, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.31.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1iihxcibjg22jxsw3s1cxzcq0rhn1rdmx4xg7qjqij981afs8dr7";
  };

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder ''out''}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder ''out''}/lib/girepository-1.0"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gobject-introspection ];

  meta = {
    homepage = https://www.gnome.org;
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    platforms = stdenv.lib.platforms.linux;
  };
}
