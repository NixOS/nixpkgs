{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobject-introspection, flex, bison, vala, gettext, gnome3, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:
let
  version = "3.32.0";
  pname = "template-glib";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1g0zx0sxpw8kqp7p3sgl9kngaqrg9xl6cir24nrahks0vgsk98rr";
  };

  buildInputs = [ meson ninja pkgconfig gettext flex bison vala glib gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  nativeBuildInputs = [ glib gobject-introspection ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library for template expansion which supports calling into GObject Introspection from templates";
    homepage = https://gitlab.gnome.org/GNOME/template-glib;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
