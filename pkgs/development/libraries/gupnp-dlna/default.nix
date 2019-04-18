{ stdenv
, fetchurl
, pkgconfig
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, libxml2
, gst_all_1
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gupnp-dlna";
  version = "0.10.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0spzd2saax7w776p5laixdam6d7smyynr9qszhbmq7f14y13cghj";
  };

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    libxml2
    gst_all_1.gst-plugins-base
  ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  postPatch = ''
    chmod +x tests/test-discoverer.sh.in
    patchShebangs tests/test-discoverer.sh.in
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GUPnP/;
    description = "Library to ease DLNA-related bits for applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
