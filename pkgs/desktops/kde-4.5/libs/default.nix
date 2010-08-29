{ kdePackage, gcc, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1
}:

kdePackage {
  pn = "kdelibs";
  v = "4.5.0";

  buildInputs = [
    cmake perl qt4 xz flex bison bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /*openexr*/ aspell avahi kerberos acl attr
    libXScrnSaver enchant libdbusmenu_qt polkit_qt_1
    automoc4 strigi soprano qca2 attica
  ];

  propagatedBuildInputs = [ shared_desktop_ontologies gcc.libc ];

  patches = [ ./polkit-install.patch ];

  # cmake fails to find acl.h because of C++-style comment
  # TODO: OpenEXR, hspell
  cmakeFlags = [
    "-DHAVE_ACL_LIBACL_H=ON" "-DHAVE_SYS_ACL_H=ON"
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    ];

  meta = {
    description = "KDE libraries";
    license = "LGPL";
  };
}
