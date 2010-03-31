{ stdenv, fetchurl, lib, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba, shared_mime_info, exiv2, libssh
, kdelibs, automoc4, phonon, strigi, soprano, cluceneCore, attica}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdebase-runtime-4.4.2.tar.bz2;
    sha256 = "087g05k2zrlwk4n7n14nblflxxm3g28nzyyyx18jr4r2xq9x64b5";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  # Still have to look into Soprano Virtuoso
  buildInputs = [ cmake perl bzip2 xz qt4 alsaLib xineLib samba stdenv.gcc.libc shared_mime_info exiv2 libssh
                  kdelibs automoc4 phonon strigi soprano cluceneCore attica ];
  meta = {
    description = "KDE runtime";
    longDescription = "Libraries and tools which supports running KDE desktop applications";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
