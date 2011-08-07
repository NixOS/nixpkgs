{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "A KDE mathematical function plotter";
    kde = {
      name = "kmplot";
    };
  };
}
