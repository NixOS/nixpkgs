{ stdenv, fetchurl, cmake, lib, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, phonon, strigi, soprano, qca2, attica, polkit_qt, enchant
}:

stdenv.mkDerivation {
  name = "kdelibs-4.4.2";

  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdelibs-4.4.2.tar.bz2;
    sha256 = "02kcw716hmkcvsz7sc823m7lzkmacb526fajkq54gxqa6fc2yr15";
  };

  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc xz flex bison bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /*openexr*/ aspell avahi kerberos acl attr
    libXScrnSaver enchant
    automoc4 phonon strigi soprano qca2 attica polkit_qt
  ];

  propagatedBuildInputs = [ shared_desktop_ontologies ];

  # cmake fails to find acl.h because of C++-style comment
  cmakeFlags = [ "-DHAVE_ACL_LIBACL_H=ON" "-DHAVE_SYS_ACL_H=ON" ];

  meta = {
    description = "KDE libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
