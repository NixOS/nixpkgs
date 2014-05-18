{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata }:

stdenv.mkDerivation rec {
  name = "libgweather-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/3.12/${name}.tar.xz";
    sha256 = "54ef096350d7774ab1b3f23ed768246301cdcedfaa762a2c46920bf87fcc1c37";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" ];
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
