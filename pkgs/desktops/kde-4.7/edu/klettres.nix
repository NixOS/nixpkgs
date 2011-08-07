{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "A KDE alphabet tutorial";
    kde = {
      name = "klettres";
    };
  };
}
