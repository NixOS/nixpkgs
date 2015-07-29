{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata, gnome3 }:

stdenv.mkDerivation rec {
  name = "libgweather-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/${gnome3.version}/${name}.tar.xz";
    sha256 = "1zadscn3i86fy7xpqiyw14pvz4f5cdw50ir77wd0zfr72hk5a2fv";
  };

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" ];
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk gnome3.geocode_glib ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
