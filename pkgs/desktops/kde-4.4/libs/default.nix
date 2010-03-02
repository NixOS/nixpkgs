{ stdenv, fetchurl, cmake, lib, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, xz, flex, bison, openexr, aspell, avahi, kerberos, acl, attr, shared_desktop_ontologies, libXScrnSaver
, automoc4, phonon, strigi, soprano, qca2, attica, polkit_qt
}:

stdenv.mkDerivation {
  name = "kdelibs-4.4.1";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdelibs-4.4.1.tar.bz2;
    sha256 = "1gw6xyfbq1scwxh4xk0k16rs24gs9067f8nnkgw4f7a1aq3xjvlv";
  };
  
  # The same way as cmake needed a patch for findqt4 to work properly under nix, 
  # also KDE, because they have their own copy of cmake's findqt4.
  patches = [ ./findqt4.patch ];

  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc xz flex bison bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /*openexr*/ aspell avahi kerberos acl attr
    libXScrnSaver
    automoc4 phonon strigi soprano qca2 attica polkit_qt
  ];

  propagatedBuildInputs = [ shared_desktop_ontologies ];


  # I don't know why cmake does not find the acl files (but finds attr files)
  cmakeFlags = [ "-DHAVE_ACL_LIBACL_H=ON" "-DHAVE_SYS_ACL_H=ON" ];
  
  meta = {
    description = "KDE libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
