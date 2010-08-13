{ kdePackage, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba,
  shared_mime_info, exiv2, libssh , kdelibs, automoc4, strigi, soprano,
  cluceneCore, attica, virtuoso, makeWrapper }:

kdePackage {
  pn = "kdebase-runtime";
  v = "4.5.0";

  buildInputs = [ cmake perl bzip2 xz qt4 alsaLib xineLib samba shared_mime_info
    exiv2 libssh kdelibs automoc4 strigi soprano cluceneCore attica
    makeWrapper];

  patches = [ ./freeze.diff ];

  postInstall = ''
    wrapProgram "$out/bin/nepomukservicestub" --prefix LD_LIBRARY_PATH : "${virtuoso}/lib" \
        --prefix PATH : "${virtuoso}/bin"
  '';

  meta = {
    description = "KDE runtime";
    longDescription = "Libraries and tools which supports running KDE desktop applications";
    license = "LGPL";
  };
}
