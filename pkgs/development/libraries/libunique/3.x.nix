{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  dbus,
  dbus-glib,
  gtk3,
  gobject-introspection,
  gtk-doc,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxslt,
  libxml2,
}:

stdenv.mkDerivation rec {

  majorVer = "3.0";
  minorVer = "2";
  version = "${majorVer}.${minorVer}";
  pname = "libunique3";
  srcName = "libunique-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/libunique/${majorVer}/${srcName}.tar.xz";
    sha256 = "0f70lkw66v9cj72q0iw1s2546r6bwwcd8idcm3621fg2fgh2rw58";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];
  buildInputs = [
    dbus
    dbus-glib
    gtk3
    gtk-doc
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
    libxml2
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/unique";
    description = "Library for writing single instance applications";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
