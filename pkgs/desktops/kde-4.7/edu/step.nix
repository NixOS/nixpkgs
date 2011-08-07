{ kde, cmake, kdelibs, qt4, automoc4, phonon, gsl, libqalculate, eigen }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon gsl libqalculate eigen ];

  meta = {
    description = "A KDE interactive physical simulator";
    kde = {
      name = "step";
    };
  };
}
