{ fetchurl, stdenv, pkgconfig, glib, gtk, libglade, bzip2
, pango, libgsf, libxml2, libart, intltool, gettext
, cairo, gconf, libgnomeui }:

stdenv.mkDerivation rec {
  name = "goffice-0.6.6";

  src = fetchurl {
    # An old version, but one that's actually usable for Gnucash.
    url = "mirror://gnome/sources/goffice/0.6/${name}.tar.bz2";
    sha256 = "11lzhmk7g6mdsbyn4p4a6q2d9m8j71vad2haw6pmzyjzv2gs4rq7";
  };

  buildInputs = [
    pkgconfig libglade bzip2 libart intltool gettext
    gconf libgnomeui
  ];

  propagatedBuildInputs = [
    # All these are in the "Requires:" field of `libgoffice-0.6.pc'.
    glib libgsf libxml2 gtk libglade libart cairo pango
  ];

  doCheck = true;

  meta = {
    description = "GOffice, a Glib/GTK+ set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = "GPLv2";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
