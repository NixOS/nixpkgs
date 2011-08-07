{ automoc4, cmake, kde, kdelibs, qt4, phonon, libXxf86vm }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon libXxf86vm ];

  meta = {
    description = "KDE monitor calibration tool";
    license = "GPLv2";
    kde.name = "kgamma";
  };
}
