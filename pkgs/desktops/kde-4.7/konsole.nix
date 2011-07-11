{ automoc4, cmake, kde, kdelibs, qt4 }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 ];

  meta = {
    description = "Konsole, the KDE terminal emulator";
    license = "GPLv2";
    kde.name = "konsole";
  };
}
