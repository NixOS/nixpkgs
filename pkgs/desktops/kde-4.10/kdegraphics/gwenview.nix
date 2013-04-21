{ kde, kdelibs, exiv2, shared_desktop_ontologies, kde_baseapps, libkipi
, libjpeg, libtiff, pkgconfig, kactivities, lcms2 }:

kde {

  buildInputs =
    [ kdelibs exiv2 shared_desktop_ontologies kactivities kde_baseapps libkipi libjpeg lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = "GPLv2";
  };
}
