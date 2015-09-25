{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" ];
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk gnome3.geocode_glib ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
