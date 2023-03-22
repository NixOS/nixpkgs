{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, intltool
, autoreconfHook
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_45
, glib
, gtk3
, lasem
, libgsf
, libxml2
, libxslt
, cairo
, pango
, librsvg
, gnome
}:

stdenv.mkDerivation rec {
  pname = "goffice";
  version = "0.10.55";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "FqIhGRhVpqbA0Gse+OSBzz9SBBplTsltNYFwRboama8=";
  };

  patches = [
    # Support lasem 0.7.
    # https://gitlab.gnome.org/GNOME/goffice/-/merge_requests/7
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/goffice/-/commit/5ebb6be7ded738c7f7a0ab32e8cf30c5115dcd51.patch";
      sha256 = "iYQSqsuR+NpXj1T7u6lSlXhHBI3h5OOvVTLDAjNHwhU=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    autoreconfHook
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    libxml2
    cairo
    pango
    libgsf
    lasem
  ];

  buildInputs = [
    libxslt
    librsvg
  ];

  configureFlags = [
    "--enable-gtk-doc"
    "--with-lasem"
  ];

  enableParallelBuilding = true;
  doCheck = !stdenv.hostPlatform.isPower64;

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
