{ kde, gcc, cmake, perl
, qt4, bzip2, fam, shared_mime_info, giflib, jasper, strigi
, openexr, avahi, kerberos, shared_desktop_ontologies, libXScrnSaver
, automoc4, soprano, qca2, attica, enchant, libdbusmenu_qt, grantlee
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1, acl, attr, libXtst
, udev, herqq, phonon, libjpeg, xz, ilmbase, libxslt
, pkgconfig
}:

kde {

# TODO: media-player-info

  buildInputs =
    [ pkgconfig attica avahi bzip2 enchant fam giflib grantlee herqq
      libdbusmenu_qt libXScrnSaver polkit_qt_1 qca2 acl jasper libxslt
      shared_desktop_ontologies xz udev libjpeg kerberos openexr
      libXtst attr
    ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  propagatedBuildInputs = [ qt4 soprano phonon strigi ];

  propagatedNativeBuildInputs = [ automoc4 cmake perl shared_mime_info ];

  # TODO: make sonnet plugins (dictionaries) really work.
  # There are a few hardcoded paths.
  # Split plugins from libs?

  patches = [ ../files/polkit-install.patch ];

  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DHUPNP_ENABLED=ON"
    "-DWITH_SOLID_UDISKS2=ON"
  ];

  passthru.wantsUdisks2 = true;

  meta = {
    description = "KDE libraries";
    license = "LGPL";
  };
}
