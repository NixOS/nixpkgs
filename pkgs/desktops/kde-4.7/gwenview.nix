{ kde, cmake, qt4, kdelibs, automoc4, exiv2, soprano
, shared_desktop_ontologies, kde_baseapps, libkipi }:

kde.package {

  buildInputs =
    [ cmake qt4 kdelibs automoc4 exiv2 soprano shared_desktop_ontologies
      kde_baseapps libkipi
    ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = "GPLv2";
    kde.name = "gwenview";
  };
}
