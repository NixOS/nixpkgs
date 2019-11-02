{ stdenv
, fetchurl
, gettext
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, pkgconfig
, meson
, ninja
, git
, vala
, glib
, zlib
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gcab";
  version = "1.3";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rv81b37d5ya7xpfdxrfk173jjcwabxyng7vafgwyl5myv44qc0h";
  };

  nativeBuildInputs = [
    meson
    ninja
    git
    pkgconfig
    vala
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    zlib
  ];

  mesonFlags = [
    "-Dtests=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "GObject library to create cabinet files";
    homepage = "https://gitlab.gnome.org/GNOME/gcab";
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
