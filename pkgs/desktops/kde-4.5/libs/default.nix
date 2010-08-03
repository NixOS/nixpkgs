{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, strigi, soprano, qca2, attica, enchant, libdbusmenu_qt
, docbook_xml_dtd_42, docbook_xsl, polkit_qt_1
}:

stdenv.mkDerivation rec {
  name = "kdelibs-4.4.95";

  src = fetchurl {
    url = "mirror://kde/unstable/4.4.95/src/${name}.tar.bz2";
    sha256 = "1fyjbdbzqxvl7rws4bvra1l4sczc1a72zdin7izif8dyjq6xblj0";
  };

  buildInputs = [
    cmake perl qt4 xz flex bison bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /*openexr*/ aspell avahi kerberos acl attr
    libXScrnSaver enchant libdbusmenu_qt polkit_qt_1
    automoc4 strigi soprano qca2 attica
  ];

  patches = [ ./python-site-packages-install-dir.diff ];

  propagatedBuildInputs = [ shared_desktop_ontologies stdenv.gcc.libc ];

  # cmake fails to find acl.h because of C++-style comment
  cmakeFlags = [
    "-DHAVE_ACL_LIBACL_H=ON" "-DHAVE_SYS_ACL_H=ON"
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    ];

  meta = with stdenv.lib; {
    description = "KDE libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
