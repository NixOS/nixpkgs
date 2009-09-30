{stdenv, fetchurl, pkgconfig, glib, gtk, pango, atk, cairo, intltool, libart_lgpl, libglade}:

stdenv.mkDerivation {
  name = "libgnomecanvas-2.26.0";
  src = fetchurl {
    url = mirror://gnome/sources/libgnomecanvas/2.26/libgnomecanvas-2.26.0.tar.bz2;
    sha256 = "13f5rf5pkp9hnyxzvssrxnlykjaixa7vrig9a7v06wrxqfn81d40";
  };
  buildInputs = [ pkgconfig gtk intltool libart_lgpl libglade ];
  CPPFLAGS = "-I${libglade}/include/libglade-2.0 -I${libart_lgpl}/include/libart-2.0 -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${atk}/include/atk-1.0 -I${cairo}/include/cairo -I${pango}/include/pango-1.0";
}
