{ automoc4, cmake, kde, kdelibs, qt4, phonon }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "KDE color chooser utility";
    license = "GPLv2";
    kde.name = "kcolorchooser";
  };
}
