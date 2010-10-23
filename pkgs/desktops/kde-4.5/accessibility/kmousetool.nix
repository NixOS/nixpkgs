{ kde, cmake, qt4, perl, automoc4, kdelibs, libXtst }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 libXtst ];

  meta = {
    description = "A program that clicks the mouse for you";
    kde = {
      name = "kmousetool";
      module = "kdeaccessibility";
      version = "1.12";
      release = "4.5.2";
      versionFile = "kmousetool/kmousetool/version.h";
    };
  };
}

