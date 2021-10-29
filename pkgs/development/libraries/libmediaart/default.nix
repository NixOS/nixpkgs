{ lib, stdenv, fetchurl, meson, ninja, pkg-config, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, gdk-pixbuf, gobject-introspection, gnome }:

stdenv.mkDerivation rec {
  pname = "libmediaart";
  version = "1.9.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1mlw1qgj8nkd9ll6b6h54r1gfdy3zp8a8xqz7qfyfaj85jjgbph7";
  };

  nativeBuildInputs = [ meson ninja pkg-config vala gtk-doc docbook_xsl docbook_xml_dtd_412 gobject-introspection ];
  buildInputs = [ glib gdk-pixbuf ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
