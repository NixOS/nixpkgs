{ stdenv, fetchurl, pkgconfig, dbus-glib, popt, which, libxml2Python, libxslt, bzip2, python
, gtk, libXau, libcanberra-gtk2
, intltool, ORBit2, libglade, libgnome, libgnomeui, libbonobo, libbonoboui, GConf, gnome_menus, gnome-desktop
, libwnck, librsvg, libgweather, gnome-doc-utils, libtasn1, libtool, xorg }:

stdenv.mkDerivation {
  name = "gnome-panel-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-panel/2.32/gnome-panel-2.32.1.tar.bz2;
    sha256 = "0pyakxyixmcp1yhi8r1q6adhamh2waj48y397fkigj11gbmjhy4g";
  };

  buildInputs =
    [ gtk dbus-glib popt libxml2Python libxslt bzip2 python libXau intltool
      ORBit2 libglade libgnome libgnomeui libbonobo libbonoboui GConf
      gnome_menus gnome-desktop libwnck librsvg libgweather gnome-doc-utils
      libtasn1 libtool libcanberra-gtk2 xorg.libICE xorg.libSM
    ];

  nativeBuildInputs = [ pkgconfig intltool which ];

  configureFlags = [ "--disable-scrollkeeper" "--disable-introspection"/*not useful AFAIK*/ ];

  NIX_CFLAGS_COMPILE="-I${GConf.dev}/include/gconf/2";
}
