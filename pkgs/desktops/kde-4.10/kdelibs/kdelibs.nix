{ kde, gcc, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, avahi, kerberos, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt, grantlee
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1
, getopt, udev, herqq, phonon, libjpeg, xz
, pkgconfig
}:

kde {
  buildInputs =
    [ pkgconfig
# attr
 attica #todo: update to 4.1
 avahi
 bzip2
 enchant
 fam
# getopt
 giflib
 grantlee # todo: update to 0.3
 herqq
 jasper
      libdbusmenu_qt #todo: update to 0.9.2
 libXScrnSaver
 libxslt
# pcre
 polkit_qt_1 qca2
      shared_desktop_ontologies xz udev
# libxml2
 libjpeg
 kerberos

#openexr # todo: update openexr to 1.7.1. make it compile maybe need ilmbase although it's supposedly propagated
    ];

  propagatedBuildInputs = [ qt4 soprano
 strigi # todo: update to 0.7.8
 phonon ];

  propagatedNativeBuildInputs = [ automoc4 cmake perl
 shared_mime_info #todo: update to 1.1
 ];

  # TODO: make sonnet plugins (dictionaries) really work.
  # There are a few hardcoded paths.
  # Let kdelibs find openexr
  # Split plugins from libs?

  patches = [ ../files/polkit-install.patch ];

  # cmake fails to find acl.h because of C++-style comment
  # TODO: OpenEXR
  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DHUPNP_ENABLED=ON"
  ];

  meta = {
    description = "KDE libraries";
    license = "LGPL";
  };
}
