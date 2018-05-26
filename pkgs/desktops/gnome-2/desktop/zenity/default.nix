{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, glib, gtk, pango, atk
, gnome-doc-utils, intltool, libglade, libX11, which, docbook_xml_dtd_412 }:

stdenv.mkDerivation {
  name = "zenity-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/zenity/2.32/zenity-2.32.1.tar.bz2;
    sha256 = "1b0qxb07wif0ds1pl8xk3fq9p874j89rf718lii4ndh7382bwf48";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ gtk libglade libxml2 libxslt libX11 docbook_xml_dtd_412 ];

  nativeBuildInputs = [ pkgconfig intltool gnome-doc-utils which ];
}
