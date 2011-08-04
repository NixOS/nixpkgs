{ kde, cmake, qt4, kdelibs, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "A type-and-say front end for speech synthesizers";
    kde = {
      name = "kmouth";
      module = "kdeaccessibility";
      version = "1.1.1";
    };
  };
}
