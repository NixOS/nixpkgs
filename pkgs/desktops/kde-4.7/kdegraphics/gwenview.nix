{ kde, kdelibs, exiv2, shared_desktop_ontologies, kde_baseapps, libkipi }:

kde {

  buildInputs =
    [ kdelibs exiv2 shared_desktop_ontologies kde_baseapps libkipi ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = "GPLv2";
  };
}
