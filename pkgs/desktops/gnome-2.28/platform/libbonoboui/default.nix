{ stdenv, fetchurl, bison, pkgconfig, popt, libxml2, cairo, glib, gtk, atk, pango
, intltool, libbonobo, GConf, libgnomecanvas, libgnome, libglade, ORBit2, libart_lgpl}:

stdenv.mkDerivation {
  name = "libbonoboui-2.24.2";
  src = fetchurl {
    url = mirror://gnome/sources/libbonoboui/2.24/libbonoboui-2.24.2.tar.bz2;
    sha256 = "005ypnzb3mfsb0k0aa3h77vwc4ifjq6r4d11msqllvx7avfgkg5f";
  };
  buildInputs = [ bison pkgconfig popt gtk libxml2
                  intltool libbonobo GConf libgnomecanvas libgnome libglade ];
	  
  # For some reason GNOME maintainers write crappy automake files and they forget to include
  # a lot of required headers (the headers may be found if they are in /usr)
  
  CPPFLAGS = "-I${cairo}/include/cairo -I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include " +
             "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${atk}/include/atk-1.0 " +
	     "-I${pango}/include/pango-1.0 -I${libgnome}/include/libgnome-2.0 -I${libbonobo}/include/libbonobo-2.0 "+
	     "-I${libbonobo}/include/bonobo-activation-2.0 -I${ORBit2}/include/orbit-2.0 -I${libxml2}/include/libxml2 "+
	     "-I${libgnomecanvas}/include/libgnomecanvas-2.0 -I${libart_lgpl}/include/libart-2.0 "+
	     "-I${GConf}/include/gconf/2 -I${libglade}/include/libglade-2.0";
  LIBS = "-lgobject-2.0 -lbonobo-2 -lgtk-x11-2.0 -lgconf-2 -lxml2 -lgnome-2 -lgnomecanvas-2";
}
