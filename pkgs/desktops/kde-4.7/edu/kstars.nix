{ kde, cmake, kdelibs, qt4, automoc4, phonon, eigen, xplanet, indilib }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon eigen xplanet indilib ];

  meta = {
    description = "A KDE graphical desktop planetarium";
    kde = {
      name = "kstars";
    };
  };
}
