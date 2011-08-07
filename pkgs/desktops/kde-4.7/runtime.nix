{ automoc4, cmake, kde, kdelibs, qt4, strigi, soprano, shared_desktop_ontologies
, bzip2, xz, shared_mime_info, libssh, exiv2, attica, phonon, libcanberra
, virtuoso, makeWrapper
}:

kde.package {

  buildInputs =
    [ phonon cmake kdelibs qt4 automoc4 strigi soprano
      shared_desktop_ontologies bzip2 xz shared_mime_info libssh
      exiv2 attica virtuoso makeWrapper
      (libcanberra.override { gtk = null; })
    ];

# Copied from kde45, Nepomuk needs it.
  postInstall = ''
    wrapProgram "$out/bin/nepomukservicestub" --prefix LD_LIBRARY_PATH : "${virtuoso}/lib" \
        --prefix PATH : "${virtuoso}/bin"
  '';

  meta = {
    license = "LGPL";
    kde.name = "kde-runtime";
  };

}
