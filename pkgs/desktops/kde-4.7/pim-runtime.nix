{ kde, fetchurl, cmake, kdelibs, qt4, phonon, libxml2, libxslt, boost
, kdepimlibs, automoc4, akonadi, soprano, strigi, shared_mime_info
, shared_desktop_ontologies }:

kde.package rec {
  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon kdepimlibs akonadi strigi
      soprano boost shared_mime_info shared_desktop_ontologies
      libxml2 libxslt
    ];

  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
    kde.name = "kdepim-runtime";
  };
}
