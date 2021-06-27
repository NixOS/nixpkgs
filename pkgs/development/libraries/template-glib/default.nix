{ lib, stdenv, fetchurl, meson, ninja, pkg-config, glib, gobject-introspection, flex, bison, vala, gettext, gnome, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:
let
  version = "3.34.0";
  pname = "template-glib";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1z9xkin5fyfh071ma9y045jcw83hgx33dfbjraw6cxk0qdmfysr1";
  };

  buildInputs = [ meson ninja pkg-config gettext flex bison vala glib gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  nativeBuildInputs = [ glib gobject-introspection ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

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
