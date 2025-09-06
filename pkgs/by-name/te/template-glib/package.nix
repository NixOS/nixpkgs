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
  docbook-xsl-nons,
  docbook_xml_dtd_43,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "template-glib";
  version = "3.37.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/template-glib/${lib.versions.majorMinor finalAttrs.version}/template-glib-${finalAttrs.version}.tar.xz";
    hash = "sha256-16xEMdWUe6KSCGx+R7iK6Kzb7A+PjTiyvbiIoL3MBhw=";
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
    docbook-xsl-nons
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
})
