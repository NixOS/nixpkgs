{ stdenv, fetchurl, pkgconfig, gettext, gobject-introspection, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, gupnp }:

stdenv.mkDerivation rec {
  name = "gupnp-igd-${version}";
  version = "0.2.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-igd/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "081v1vhkbz3wayv49xfiskvrmvnpx93k25am2wnarg5cifiiljlb";
  };

  nativeBuildInputs = [ pkgconfig gettext gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  propagatedBuildInputs = [ glib gupnp ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library to handle UPnP IGD port mapping";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
