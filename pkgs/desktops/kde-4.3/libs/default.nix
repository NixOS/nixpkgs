{ stdenv, fetchurl, cmake, lib, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.3.4";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdelibs-4.3.4.tar.bz2;
    sha1 = "1af2d185c88898b71f36b57f033e3a6d9839ab3d";
  };
  
  includeAllQtDirs = true;

  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc xz flex bison bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /* openexr */ aspell avahi kerberos acl attr
    automoc4 phonon strigi soprano
  ];

  # I don't know why cmake does not find the acl files (but finds attr files)
  cmakeFlags = [ "-DHAVE_ACL_LIBACL_H=ON" "-DHAVE_SYS_ACL_H=ON" ];
  
  meta = {
    description = "KDE libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
