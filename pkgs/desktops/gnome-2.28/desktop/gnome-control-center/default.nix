{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, libxklavier, hal, cairo, popt, which, python
, shared_mime_info, desktop_file_utils
, glib, gtk, pango, atk, gnome_doc_utils, intltool, GConf, libglade, libgnome, libgnomeui, libgnomekbd
, librsvg, gnome_menus, gnome_desktop, gnome_panel, metacity, gnome_settings_daemon
, libbonobo, libbonoboui, libgnomecanvas, libart_lgpl, gnome_vfs, ORBit2}:

stdenv.mkDerivation {
  name = "gnome-control-center-2.28.0";
  src = fetchurl {
    url = mirror:/gnome/sources/gnome-control-center/2.28/gnome-control-center-2.28.0.tar.bz2;
    sha256 = "0m0z7dn5qzl63cpc8ivagm4yfsfgigfawl5v3df3pw3z4jk2bsfp"
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt libxklavier hal popt which python shared_mime_info desktop_file_utils
                  gtk gnome_doc_utils intltool GConf libglade libgnomekbd
                  libgnomeui librsvg gnome_menus gnome_desktop gnome_panel metacity gnome_settings_daemon ];
  configureFlags = "--disable-scrollkeeper";
  # This makes me cry
  CPPFLAGS = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include "+
             "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${cairo}/include/cairo "+
             "-I${pango}/include/pango-1.0 -I${atk}/include/atk-1.0 "+
	     "-I${gnome_desktop}/include/gnome-desktop-2.0 -I${gnome_menus}/include/gnome-menus "+
	     "-I${libgnomeui}/include/libgnomeui-2.0 -I${libbonoboui}/include/libbonoboui-2.0 "+
	     "-I${libgnomecanvas}/include/libgnomecanvas-2.0 -I${libart_lgpl}/include/libart-2.0 "+
	     "-I${libgnome}/include/libgnome-2.0 -I${gnome_vfs}/include/gnome-vfs-2.0 "+
	     "-I${libbonobo}/include/libbonobo-2.0 -I${libbonobo}/include/bonobo-activation-2.0 "+
	     "-I${ORBit2}/include/orbit-2.0 -I${GConf}/include/gconf/2 -I${librsvg}/include/librsvg-2 "+
	     "-I${gnome_panel}/include/panel-2.0";
  LIBS = "-lXft -lglib-2.0 -lgtk-x11-2.0 -lrsvg-2 -lgconf-2 -lgnome-desktop-2 -lgnome-menu -lgnomeui-2";
}
