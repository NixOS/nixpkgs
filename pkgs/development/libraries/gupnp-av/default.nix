{ lib, stdenv
, fetchurl
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, glib
, libxml2
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gupnp-av";
  version = "0.12.11";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1p3grslwqm9bc8rmpn4l48d7v9s84nina4r9xbd932dbj8acz7b8";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    libxml2
  ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "http://gupnp.org/";
    description = "A collection of helpers for building AV (audio/video) applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
