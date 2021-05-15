{ lib
, stdenv
, fetchurl
, pkg-config
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
}:

stdenv.mkDerivation rec {
  pname = "libqrtr-glib";
  version = "1.0.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "MNh5sq3m+PRh3vOmd3VdtcAji6v2iNXIPAOz5qvjXO4=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
  ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib";
    description = "Qualcomm IPC Router protocol helper library";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
