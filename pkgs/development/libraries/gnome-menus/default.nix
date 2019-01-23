{ stdenv, fetchurl, intltool, pkgconfig, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.31.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11i5m0w15by1k8d94xla54nr4r8nnb63wk6iq0dzki4cv5d55qgw";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib gobject-introspection ];

  meta = {
    homepage = https://www.gnome.org;
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    platforms = stdenv.lib.platforms.linux;
  };
}
