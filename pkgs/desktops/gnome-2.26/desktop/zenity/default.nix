{stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, glib, gtk, pango, atk, gnome_doc_utils, intltool, libglade}:

stdenv.mkDerivation {
  name = "zenity-2.26.0";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/zenity-2.26.0.tar.bz2;
    sha256 = "1882sh83jp3drg5z61rghdshnsfys4jgbgg7za7b9jlhr8ar4qgw";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig gtk gnome_doc_utils intltool libglade libxml2 libxslt ];
  CPPFLAGS = "-I${cairo}/include/cairo -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include "+
             "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${pango}/include/pango-1.0 "+
	     "-I${atk}/include/atk-1.0 -I${libglade}/include/libglade-2.0";
  LIBS = "-lgtk-x11-2.0 -lglade-2.0";
}
