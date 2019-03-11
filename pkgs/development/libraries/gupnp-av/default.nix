{ stdenv, fetchurl, pkgconfig, gobject-introspection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, gupnp, glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "gupnp-av-${version}";
  version = "0.12.11";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1p3grslwqm9bc8rmpn4l48d7v9s84nina4r9xbd932dbj8acz7b8";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection vala gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  buildInputs = [ gupnp glib libxml2 ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://gupnp.org/;
    description = "A collection of helpers for building AV (audio/video) applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
