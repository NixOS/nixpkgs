{ stdenv, fetchurl, pkgconfig, libxml2, popt, cairo, libX11, libICE, glib, gtk, atk, pango
, intltool, libgnome, libgnomecanvas, libbonobo, libbonoboui, GConf
, gnome_vfs, gnome_keyring, libglade, libart_lgpl, ORBit2}:

stdenv.mkDerivation {
  name = "libgnomeui-2.24.2";
  src = fetchurl {
    url = mirror://gnome/sources/libgnomeui/2.24/libgnomeui-2.24.2.tar.bz2;
    sha256 = "04296nf6agg8zsbw6pzl3mzn890bkcczs6fnna5jay7fvnrmjx5f";
  };
  buildInputs = [ pkgconfig libxml2 popt libX11 libICE glib gtk pango
                  intltool libgnome libgnomecanvas libbonoboui GConf gnome_vfs gnome_keyring libglade ];
  CPPFLAGS = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${atk}/include/atk-1.0 "+
             "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${libbonoboui}/include/libbonoboui-2.0 "+
	     "-I${cairo}/include/cairo -I${pango}/include/pango-1.0 -I${libgnomecanvas}/include/libgnomecanvas-2.0 "+
	     "-I${libgnome}/include/libgnome-2.0 -I${libart_lgpl}/include/libart-2.0 -I${gnome_vfs}/include/gnome-vfs-2.0 "+
	     "-I${libbonobo}/include/libbonobo-2.0 -I${GConf}/include/gconf/2 -I${libxml2}/include/libxml2 "+
	     "-I${libbonobo}/include/bonobo-activation-2.0 -I${ORBit2}/include/orbit-2.0 "+
	     "-I${gnome_keyring}/include/gnome-keyring-1 -I${libglade}/include/libglade-2.0";
  LIBS = "-lgtk-x11-2.0 -lgnomecanvas-2 -lgconf-2 -lbonoboui-2 -lgnome-keyring";
}
