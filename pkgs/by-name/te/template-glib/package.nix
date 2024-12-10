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
  version = "3.36.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-ACDzpAGIjOdjs6F1CML1jpGXKkg6DFR6/bfMviVhmUg=";
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
    description = "Library for template expansion which supports calling into GObject Introspection from templates";
    homepage = "https://gitlab.gnome.org/GNOME/template-glib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
