{ fetchurl, lib, stdenv, pkg-config, intltool, glib, gtk3, lasem
, libgsf, libxml2, libxslt, cairo, pango, librsvg, gnome }:

stdenv.mkDerivation rec {
  pname = "goffice";
  version = "0.10.50";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "LFw93HsIs0UkCMgbEhxfASpzSYHXXkRN68yxxY5cv9w=";
  };

  nativeBuildInputs = [ pkg-config intltool ];

  propagatedBuildInputs = [
    glib gtk3 libxml2 cairo pango libgsf lasem
  ];

  buildInputs = [ libxslt librsvg ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "A Glib/GTK set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
  };
}
