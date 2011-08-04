{ kde, cmake, qt4, kdelibs, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "Screen magnifier for KDE";
    kde = {
      name = "kmag";
      module = "kdeaccessibility";
      version = "1.0";
      versionFile = "kmag/version.h";
    };
  };
}

