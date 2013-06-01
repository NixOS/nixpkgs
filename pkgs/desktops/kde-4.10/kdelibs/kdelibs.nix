{ kde, gcc, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, avahi, kerberos, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt, grantlee
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1
, getopt, udev, herqq, phonon, libjpeg, xz, ilmbase
, pkgconfig
}:

kde {
  buildInputs =
    [ pkgconfig attica avahi bzip2 enchant fam giflib grantlee herqq jasper
      libdbusmenu_qt libXScrnSaver libxslt polkit_qt_1 qca2
      shared_desktop_ontologies xz udev libjpeg kerberos openexr
    ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  propagatedBuildInputs = [ qt4 soprano strigi phonon ];

  propagatedNativeBuildInputs = [ automoc4 cmake perl shared_mime_info ];

  # TODO: make sonnet plugins (dictionaries) really work.
  # There are a few hardcoded paths.
  # Split plugins from libs?

  patches = [ ../files/polkit-install.patch ];

  # cmake fails to find acl.h because of C++-style comment

  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DHUPNP_ENABLED=ON"
  ];

  passthru.wantsUdisks2 = false;

  meta = {
    description = "KDE libraries";
    license = "LGPL";
  };
}
