{ kde, cmake, qt4, kdelibs, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "Bridge that provides accessibility services to applications";
    kde = {
      name = "kaccessible";
      module = "kdeaccessibility";
    };
  };
}
  