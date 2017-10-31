{ stdenv, fetchurl, pkgconfig, dbus_glib, dbus, cairo, popt, which, libxml2Python, libxslt, bzip2, python
, glib, gtk, pango, atk, libXau, libcanberra
, intltool, ORBit2, libglade, libgnome, libgnomeui, libbonobo, libbonoboui, GConf, gnome_menus, gnome_desktop
, libwnck, librsvg, libgweather, gnome_doc_utils, libgnomecanvas, libart_lgpl, libtasn1, libtool, xorg }:

stdenv.mkDerivation {
  name = "gnome-panel-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-panel/2.32/gnome-panel-2.32.1.tar.bz2;
    sha256 = "0pyakxyixmcp1yhi8r1q6adhamh2waj48y397fkigj11gbmjhy4g";
  };

  buildInputs =
    [ gtk dbus_glib popt libxml2Python libxslt bzip2 python libXau intltool
      ORBit2 libglade libgnome libgnomeui libbonobo libbonoboui GConf
      gnome_menus gnome_desktop libwnck librsvg libgweather gnome_doc_utils
      libtasn1 libtool libcanberra xorg.libICE xorg.libSM
    ];

  nativeBuildInputs = [ pkgconfig intltool which ];

  configureFlags = [ "--disable-scrollkeeper" "--disable-introspection"/*not useful AFAIK*/ ];

  NIX_CFLAGS_COMPILE="-I${GConf.dev}/include/gconf/2";
}
