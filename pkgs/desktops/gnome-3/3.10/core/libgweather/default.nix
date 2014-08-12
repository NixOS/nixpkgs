{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata }:

stdenv.mkDerivation rec {
  name = "libgweather-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/3.10/${name}.tar.xz";
    sha256 = "1iyg0l90m14iw0ksjbmrrhb5fqn0y7x5f726y56gxd4qcxgpi3mf";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" ];
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
