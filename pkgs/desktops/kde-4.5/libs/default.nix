{ kde, gcc, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1, hspell
}:

kde.package {

  buildInputs = [
    cmake perl xz flex bison bzip2 pcre fam libxml2 libxslt shared_mime_info
    giflib jasper /*openexr*/ aspell avahi kerberos acl attr libXScrnSaver
    enchant libdbusmenu_qt polkit_qt_1 automoc4 hspell
  ];

# TODO: make sonnet plugins (dictionaries) really work.
# There are a few hardcoded paths.
# Let kdelibs find openexr
# Split plugins from libs?

  propagatedBuildInputs = [ qt4 gcc.libc strigi soprano attica qca2
    shared_desktop_ontologies ];

  patches = [ ./polkit-install.patch ];

  # cmake fails to find acl.h because of C++-style comment
  # TODO: OpenEXR, hspell
  cmakeFlags = ''
    -DHAVE_ACL_LIBACL_H=ON -DHAVE_SYS_ACL_H=ON
    -DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook
    -DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook
    '';

  meta = {
    description = "KDE libraries";
    license = "LGPL";
    kde = {
      name = "kdelibs";
      version = "4.5.2";
    };
  };
}
