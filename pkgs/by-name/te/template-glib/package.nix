{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gobject-introspection,
  flex,
  bison,
  vala,
  gettext,
  gnome,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_43,
}:

stdenv.mkDerivation rec {
  pname = "template-glib";
  version = "3.36.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/template-glib/${lib.versions.majorMinor version}/template-glib-${version}.tar.xz";
    hash = "sha256-1SizWyz5Dgfa5Q4l4S+62w6wSPV/1RUc+fbpjM4d8g4=";
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
      packageName = "template-glib";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library for template expansion which supports calling into GObject Introspection from templates";
    homepage = "https://gitlab.gnome.org/GNOME/template-glib";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
