{ fetchurl, lib, stdenv, pkg-config, intltool, glib, gtk3, lasem
, libgsf, libxml2, libxslt, cairo, pango, librsvg, gnome
, autoreconfHook
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "goffice";
  version = "0.10.57";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-Zr/X4x0vZ1bVpiw2cDg8u6ArPLTBBClQGSqAG3Kjyas=";
  };

  nativeBuildInputs = [
    pkg-config intltool autoreconfHook gtk-doc
    glib  # for glib-genmarshal
  ];

  propagatedBuildInputs = [
    glib gtk3 libxml2 cairo pango libgsf lasem
  ];

  buildInputs = [ libxslt librsvg ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Glib/GTK set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
  };
}
