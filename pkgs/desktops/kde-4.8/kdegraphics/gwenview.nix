{ kde, kdelibs, exiv2, shared_desktop_ontologies, kde_baseapps, libkipi
, libjpeg, pkgconfig }:

kde {

  buildInputs =
    [ kdelibs exiv2 shared_desktop_ontologies kde_baseapps libkipi libjpeg ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = "GPLv2";
  };
}
