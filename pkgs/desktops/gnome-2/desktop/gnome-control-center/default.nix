{ stdenv, fetchurl, pkgconfig, dbus-glib, libxml2Python, libxslt, libxklavier, cairo, popt, which, python
, shared-mime-info, desktop-file-utils, libunique, libtool, bzip2
, glib, gtk, pango, atk, gnome-doc-utils, intltool, GConf, libglade, libgnome, libgnomeui, libgnomekbd
, librsvg, gnome_menus, gnome-desktop, gnome_panel, metacity, gnome-settings-daemon
, libbonobo, libbonoboui, libgnomecanvas, libart_lgpl, gnome_vfs, ORBit2
, libSM, docbook_xml_dtd_412 }:

stdenv.mkDerivation {
  name = "gnome-control-center-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-control-center/2.32/gnome-control-center-2.32.1.tar.bz2;
    sha256 = "0rkyg6naidql0nv74608mlsr2lzjgnndnxnxv3s0hp4f6mbqnmkw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus-glib libxml2Python libxslt libxklavier popt which python shared-mime-info desktop-file-utils
                  gtk gnome-doc-utils intltool GConf libglade libgnomekbd libunique libtool bzip2
                  libgnomeui librsvg gnome_menus gnome-desktop gnome_panel metacity gnome-settings-daemon
                  libSM docbook_xml_dtd_412
  ];
  configureFlags = "--disable-scrollkeeper";
}
