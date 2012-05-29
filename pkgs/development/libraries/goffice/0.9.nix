{ fetchurl, stdenv, pkgconfig, glib, gtk, libglade, bzip2
, pango, libgsf, libxml2, libart, librsvg, intltool, gettext
, cairo, gconf, libgnomeui }:

stdenv.mkDerivation rec {
  name = "goffice-0.9.3";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.9/${name}.tar.xz";
    sha256 = "0l9achvmbmhn2p5qd0nl7vxn5c3nf1ndzlyknczzyiaa6d5zj91h";
  };

  buildInputs = [
    pkgconfig libglade bzip2 libart intltool gettext
    gconf libgnomeui
  ];

  propagatedBuildInputs = [
    glib libgsf libxml2 gtk libglade libart librsvg cairo pango
  ];

  doCheck = true;

  meta = {
    description = "GOffice, a Glib/GTK+ set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = "GPLv2+";

    platforms = stdenv.lib.platforms.gnu;
  };
}
