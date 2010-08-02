{ stdenv, fetchurl, lib, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba, shared_mime_info, exiv2, libssh
, kdelibs, automoc4, phonon, strigi, soprano, cluceneCore, attica, virtuoso, makeWrapper }:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdebase-runtime-4.4.5.tar.bz2;
    sha256 = "0a0lg0vkdq8v3rydg6n6nk3gqc3vn3sz2rn5gzm0vd2k5wyy8frx";
  };

/*  CLUCENE_HOME=cluceneCore;*/
  buildInputs = [ cmake perl bzip2 xz qt4 alsaLib xineLib samba stdenv.gcc.libc shared_mime_info exiv2 libssh
                  kdelibs automoc4 phonon strigi soprano cluceneCore attica makeWrapper];

  postInstall = ''
    wrapProgram "$out/bin/nepomukservicestub" --prefix LD_LIBRARY_PATH : "${virtuoso}/lib" \
        --prefix PATH : "${virtuoso}/bin"
  '';

  meta = {
    description = "KDE runtime";
    longDescription = "Libraries and tools which supports running KDE desktop applications";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
