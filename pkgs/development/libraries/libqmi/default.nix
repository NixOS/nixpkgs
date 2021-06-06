{ lib
, stdenv
, fetchurl
, pkg-config
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, python3
, libgudev
, libmbim
, libqrtr-glib
}:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.28.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "jIw+5xmHTSUpvOmzWwKP5DWzbwA5eaNg060JOESdt4M=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    python3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    libgudev
    libmbim
  ];

  propagatedBuildInputs = [
    glib
    libqrtr-glib
  ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--enable-gtk-doc"
    "--enable-introspection"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = with licenses; [
      # Library
      lgpl2Plus
      # Tools
      gpl2Plus
    ];
  };
}
