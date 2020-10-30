{ fetchurl, stdenv, pkgconfig, intltool, glib, gtk3, lasem
, libgsf, libxml2, libxslt, cairo, pango, librsvg, gnome3 }:

stdenv.mkDerivation rec {
  pname = "goffice";
  version = "0.10.48";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1z6f3q8fxkd1ysqrwdxdi0844zqa00vjpf07gq8mh3kal8picfd4";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [
    glib gtk3 libxml2 cairo pango libgsf lasem
  ];

  buildInputs = [ libxslt librsvg ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "A Glib/GTK set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
  };
}
