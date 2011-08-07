{ kde, cmake, qt4, kdelibs, automoc4, exiv2, soprano
, shared_desktop_ontologies, kde_baseapps, libkipi, phonon
}:

kde.package {

  buildInputs =
    [ cmake qt4 kdelibs automoc4 exiv2 soprano shared_desktop_ontologies
      kde_baseapps libkipi phonon
    ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = "GPLv2";
    kde.name = "gwenview";
  };
}
