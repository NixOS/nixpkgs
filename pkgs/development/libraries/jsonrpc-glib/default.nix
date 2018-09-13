{ stdenv, fetchurl, meson, ninja, glib, json-glib, pkgconfig, gobjectIntrospection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_43, gnome3 }:
let
  version = "3.30.0";
  pname = "jsonrpc-glib";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection vala gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = [ glib json-glib ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0z7v2kld9gyh0faarbs82vrdvg8h6a01x9mxlrwkxbghjgmq05w4";
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
