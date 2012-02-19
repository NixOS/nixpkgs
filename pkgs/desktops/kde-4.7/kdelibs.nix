{ kde, gcc, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1
, getopt, udev, herqq, phonon, libjpeg, xz
}:

kde {
  buildInputs =
    [ acl attr attica avahi bzip2 enchant fam getopt giflib herqq jasper
      libdbusmenu_qt libXScrnSaver libxslt pcre polkit_qt_1 qca2
      shared_desktop_ontologies xz udev libxml2 libjpeg kerberos
    ];

  propagatedBuildInputs = [ qt4 soprano strigi phonon ];

  propagatedBuildNativeInputs = [ automoc4 cmake perl shared_mime_info ];

  # TODO: make sonnet plugins (dictionaries) really work.
  # There are a few hardcoded paths.
  # Let kdelibs find openexr
  # Split plugins from libs?

  patches = [ ./files/polkit-install.patch ];

  # cmake fails to find acl.h because of C++-style comment
  # TODO: OpenEXR
  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
  ];

  meta = {
    description = "KDE libraries";
    license = "LGPL";
  };
}
