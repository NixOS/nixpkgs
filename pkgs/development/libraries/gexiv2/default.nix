{ lib, stdenv, fetchurl, meson, ninja, pkg-config, exiv2, glib, gnome, gobject-introspection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:

stdenv.mkDerivation rec {
  pname = "gexiv2";
  version = "0.12.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0jt5cqL8b4QBULrR7XnBy+xnKVHhgMHh7DPKbHMMWfM=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gobject-introspection vala gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ exiv2 ];

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
    homepage = "https://wiki.gnome.org/Projects/gexiv2";
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
