{ stdenv, fetchurl, cmake, lib, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.3.5";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdelibs-4.3.5.tar.bz2;
    sha256 = "03mlwj7pn0k4g50j196cfqsiqf2gfwixppgka695gxmlw8s3x0k5";
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
