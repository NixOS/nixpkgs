{ automoc4, cmake, kde, kdelibs, qt4, phonon }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "Interface library to kipi-plugins";
    license = "GPLv2";
    kde.name = "libkipi";
  };
}
