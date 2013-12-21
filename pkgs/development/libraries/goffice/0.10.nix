{ fetchurl, stdenv, pkgconfig, glib, gtk, libglade, bzip2
, pango, libgsf, libxml2, libart, librsvg, intltool, gettext
, cairo, gconf, libgnomeui }:

stdenv.mkDerivation rec {
  name = "goffice-0.10.9";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.10/${name}.tar.xz";
    sha256 = "0xc82hymhkdglnksd3r7405p39d5ym826rwaa7dfkps5crjwq8cg";
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
