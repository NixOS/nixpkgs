{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "Floppy disk formatting utility";
    kde = {
      name = "kfloppy";
      module = "kdeutils";
    };
  };
}
