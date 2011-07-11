{ automoc4, cmake, kde, kdelibs, qt4 }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 ];

  meta = {
    description = "KDE color chooser utility";
    license = "GPLv2";
    kde.name = "kcolorchooser";
  };
}
