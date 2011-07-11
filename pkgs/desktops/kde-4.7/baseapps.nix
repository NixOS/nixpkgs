{ automoc4, cmake, kde, kdelibs, qt4, strigi, soprano
, shared_desktop_ontologies, glib
}:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 strigi soprano shared_desktop_ontologies
      glib
    ];

  meta = {
    description = "Base KDE applications, including the Dolphin file manager and Konqueror web browser";
    license = "GPLv2";
    kde.name = "kde-baseapps";
  };
}
