{stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, glib, gtk, pango, atk, gnome_doc_utils, intltool, libglade,
  libX11}:

stdenv.mkDerivation {
  name = "zenity-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/zenity/2.28/zenity-2.28.0.tar.bz2;
    sha256 = "0qwcrkgqsldxmh29xlbakh6lc3qz8sp6kmk1ca7fc3kbwhya4irp";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig gtk gnome_doc_utils intltool libglade libxml2 libxslt libX11];
  CPPFLAGS = "-I${cairo}/include/cairo -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include "+
             "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${pango}/include/pango-1.0 "+
	     "-I${atk}/include/atk-1.0 -I${libglade}/include/libglade-2.0";
  LIBS = "-lgtk-x11-2.0 -lglade-2.0 -lX11";
}
