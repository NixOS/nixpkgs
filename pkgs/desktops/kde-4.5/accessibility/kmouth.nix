{ kde, cmake, qt4, perl, automoc4, kdelibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "A type-and-say front end for speech synthesizers";
    kde = {
      name = "kmouth";
      module = "kdeaccessibility";
      version = "1.1.1";
      release = "4.5.2";
      versionFile = "kmouth/version.h";
    };
  };
}

