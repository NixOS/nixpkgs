{ stdenv, fetchurl, pkgconfig, gobjectIntrospection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, libsoup, gtk3, glib }:

stdenv.mkDerivation rec {
  name = "gssdp-${version}";
  version = "1.0.2";

  outputs = [ "out" "bin" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1p1m2m3ndzr2whipqw4vfb6s6ia0g7rnzzc4pnq8b8g1qw4prqd1";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection vala gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  buildInputs = [ libsoup gtk3 ];
  propagatedBuildInputs = [ glib ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
