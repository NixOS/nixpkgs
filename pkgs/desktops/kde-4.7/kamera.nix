{ automoc4, cmake, kde, kdelibs, qt4, phonon, libgphoto2 }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon libgphoto2 ];

  meta = {
    description = "KDE camera interface library";
    license = "GPLv2";
    kde.name = "kamera";
  };
}
