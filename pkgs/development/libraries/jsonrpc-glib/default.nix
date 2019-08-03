{ stdenv, fetchurl, meson, ninja, glib, json-glib, pkgconfig, gobject-introspection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_43, gnome3 }:
stdenv.mkDerivation rec {
  pname = "jsonrpc-glib";
  version = "3.32.0";

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection vala gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = [ glib json-glib ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sx6xvzzdm9k0vfmpgg07abz7a9kar20h1a9ml0wgjdxr0valq5w";
  };

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  # Tests fail non-deterministically
  # https://gitlab.gnome.org/GNOME/jsonrpc-glib/issues/2
  doCheck = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library to communicate using the JSON-RPC 2.0 specification";
    homepage = https://gitlab.gnome.org/GNOME/jsonrpc-glib;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
