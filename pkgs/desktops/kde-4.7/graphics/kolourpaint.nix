{ automoc4, cmake, kde, kdelibs, qt4, phonon, qimageblitz }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon qimageblitz ];

  meta = {
    description = "KDE paint program"; 
    license = "GPLv2";
    kde.name = "kolourpaint";
  };
}
