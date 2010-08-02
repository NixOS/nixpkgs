{ stdenv, fetchurl, pkgconfig, dbus_glib, dbus, cairo, popt, which, libxml2, libxslt, bzip2, python
, glib, gtk, pango, atk, libXau
, intltool, ORBit2, libglade, libgnome, libgnomeui, libbonobo, libbonoboui, GConf, gnome_menus, gnome_desktop
, libwnck, librsvg, libgweather, gnome_doc_utils, libgnomecanvas, libart_lgpl, libtasn1}:

stdenv.mkDerivation {
  name = "gnome-panel-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-panel/2.28/gnome-panel-2.28.0.tar.bz2;
    sha256 = "0rc4f6vmyrm3s8ncbll0a1ik2j1gg068fq3xal120sc4iw68q5n1";
  };
  buildInputs = [ pkgconfig gtk dbus_glib popt which libxml2 libxslt bzip2 python libXau
                  intltool ORBit2 libglade libgnome libgnomeui libbonobo libbonoboui GConf gnome_menus gnome_desktop 
		  libwnck librsvg libgweather gnome_doc_utils libtasn1 ];
  configureFlags = "--disable-scrollkeeper";
  CPPFLAGS = "-I${glib}/include/glib-2.0 -I${glib}/include/gio-unix-2.0 -I${glib}/lib/glib-2.0/include -I${dbus_glib}/include/dbus-1.0 -I${dbus.libs}/include/dbus-1.0 "+
             "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${cairo}/include/cairo -I${pango}/include/pango-1.0 "+
	     "-I${atk}/include/atk-1.0 -I${ORBit2}/include/orbit-2.0 -I${libbonobo}/include/bonobo-activation-2.0 "+
	     "-I${libgnomeui}/include/libgnomeui-2.0 -I${libgnome}/include/libgnome-2.0 -I${GConf}/include/gconf/2 "+
	     "-I${libglade}/include/libglade-2.0 -I${gnome_menus}/include/gnome-menus -I${gnome_desktop}/include/gnome-desktop-2.0 "+
	     "-I${libbonoboui}/include/libbonoboui-2.0 -I${libbonobo}/include/libbonobo-2.0 -I${libgnomecanvas}/include/libgnomecanvas-2.0 "+
	     "-I${libart_lgpl}/include/libart-2.0 -I${librsvg}/include/librsvg-2 -I${libwnck}/include/libwnck-1.0";
  LIBS = "-lORBit-2 -lbonobo-2 -lgtk-x11-2.0 -lgconf-2 -lgnomeui-2 -lglade-2.0 -lgnome-menu -lgnome-desktop-2 -lrsvg-2 -lwnck-1";
}
