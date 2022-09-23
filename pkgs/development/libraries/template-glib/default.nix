{ lib, stdenv, fetchurl, meson, ninja, pkg-config, glib, gobject-introspection, flex, bison, vala, gettext, gnome, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:
let
  version = "3.34.1";
  pname = "template-glib";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nsm3HgTU9csU91XveQYxzQtFwGA+Ecg2/Hz9niaM0Ho=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext flex bison vala glib gtk-doc docbook_xsl docbook_xml_dtd_43 gobject-introspection ];
  buildInputs = [ glib ];

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
