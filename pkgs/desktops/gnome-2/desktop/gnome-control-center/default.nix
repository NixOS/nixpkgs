{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2Python, libxslt, libxklavier, cairo, popt, which, python
, shared_mime_info, desktop_file_utils, libunique, libtool, bzip2
, glib, gtk, pango, atk, gnome_doc_utils, intltool, GConf, libglade, libgnome, libgnomeui, libgnomekbd
, librsvg, gnome_menus, gnome_desktop, gnome_panel, metacity, gnome_settings_daemon
, libbonobo, libbonoboui, libgnomecanvas, libart_lgpl, gnome_vfs, ORBit2
, libSM }:

stdenv.mkDerivation {
  name = "gnome-control-center-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-control-center/2.32/gnome-control-center-2.32.1.tar.bz2;
    sha256 = "0rkyg6naidql0nv74608mlsr2lzjgnndnxnxv3s0hp4f6mbqnmkw";
  };

  buildInputs = [ pkgconfig dbus_glib libxml2Python libxslt libxklavier popt which python shared_mime_info desktop_file_utils
                  gtk gnome_doc_utils intltool GConf libglade libgnomekbd libunique libtool bzip2 
                  libgnomeui librsvg gnome_menus gnome_desktop gnome_panel metacity gnome_settings_daemon
                  libSM
  ];
  configureFlags = "--disable-scrollkeeper";
}
