{ kde, cmake, qt4, kdelibs, automoc4, phonon, libXtst }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon libXtst ];

  meta = {
    description = "A program that clicks the mouse for you";
    kde = {
      name = "kmousetool";
      module = "kdeaccessibility";
      version = "1.12";
      versionFile = "kmousetool/kmousetool/version.h";
    };
  };
}
