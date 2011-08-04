{ automoc4, cmake, kde, kdelibs, qt4, libkipi, phonon }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 libkipi phonon ];

  meta = {
    description = "KDE screenshot utility";
    license = "GPLv2";
    kde.name = "ksnapshot";
  };
}
