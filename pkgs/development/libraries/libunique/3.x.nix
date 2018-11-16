{ stdenv, fetchurl, pkgconfig
, dbus, dbus-glib, gtk3, gobjectIntrospection
, gtkdoc, docbook_xml_dtd_45, docbook_xsl
, libxslt, libxml2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  majorVer = "3.0";
  minorVer = "2";
  version = "${majorVer}.${minorVer}";
  name = "libunique3-${version}";
  srcName = "libunique-${version}";  

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/libunique/${majorVer}/${srcName}.tar.xz";
    sha256 = "0f70lkw66v9cj72q0iw1s2546r6bwwcd8idcm3621fg2fgh2rw58";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus dbus-glib gtk3 gobjectIntrospection gtkdoc docbook_xml_dtd_45 docbook_xsl libxslt libxml2 ];

  meta = {
    homepage = https://wiki.gnome.org/Attic/LibUnique;
    description = "A library for writing single instance applications";
    license = licenses.lgpl21;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
