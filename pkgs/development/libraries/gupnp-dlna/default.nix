{ stdenv, fetchurl, pkgconfig, gobject-introspection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, gupnp, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "gupnp-dlna-${version}";
  version = "0.10.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-dlna/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0spzd2saax7w776p5laixdam6d7smyynr9qszhbmq7f14y13cghj";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection vala gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  buildInputs = [ gupnp gst_all_1.gst-plugins-base ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  postPatch = ''
    chmod +x tests/test-discoverer.sh.in
    patchShebangs tests/test-discoverer.sh.in
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GUPnP/;
    description = "Library to ease DLNA-related bits for applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
