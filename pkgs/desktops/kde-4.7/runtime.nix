{ automoc4, cmake, kde, kdelibs, qt4, strigi, soprano, shared_desktop_ontologies
, bzip2, xz, shared_mime_info, libssh, exiv2, attica, phonon, libcanberra
}:

kde.package {

  buildInputs =
    [ phonon cmake kdelibs qt4 automoc4 strigi soprano
      shared_desktop_ontologies bzip2 xz shared_mime_info libssh
      exiv2 attica
      (libcanberra.override { gtk = null; })
    ];

  meta = {
    license = "LGPL";
    kde.name = "kde-runtime";
  };

}
