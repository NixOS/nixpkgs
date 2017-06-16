{ fetchurl, stdenv, pkgconfig, intltool, glib, gtk3
, libgsf, libxml2, libxslt, cairo, pango, librsvg, libspectre }:

stdenv.mkDerivation rec {
  name = "goffice-0.10.34";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.10/${name}.tar.xz";
    sha256 = "554a75a22b5863b3b17595148bee6462122f2dbf031dfa78b61e941e3c2dd603";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [ # ToDo lasem library for MathML, opt. introspection?
    glib gtk3 libxml2 cairo pango libgsf
  ];

  buildInputs = [ libxslt librsvg ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    description = "A Glib/GTK+ set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
  };
}
