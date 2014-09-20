{ stdenv, kde, kdelibs, exiv2, kde_baseapps, libkipi, nepomuk_core
, libjpeg, pkgconfig, kactivities, lcms2 }:

kde {

  buildInputs =
    [ kdelibs exiv2 nepomuk_core kactivities kde_baseapps libkipi libjpeg lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Gwenview, the KDE image viewer";
    license = stdenv.lib.licenses.gpl2;
  };
}
