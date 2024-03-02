{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, glib
, gobject-introspection
, flex
, bison
, vala
, gettext
, gnome
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
}:

stdenv.mkDerivation rec {
  pname = "template-glib";
  version = "3.36.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "OxZ6Fzha10WvviD634EGxm0wxb10bVqh2b236AP2pQM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    flex
    bison
    vala
    glib
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library for template expansion which supports calling into GObject Introspection from templates";
    homepage = "https://gitlab.gnome.org/GNOME/template-glib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
