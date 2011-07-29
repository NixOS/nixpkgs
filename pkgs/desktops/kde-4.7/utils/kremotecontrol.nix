{ kde, cmake, kdelibs, qt4, automoc4, phonon, libXtst }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon libXtst ];

  meta = {
    description = "KDE remote control";
    kde = {
      name = "kremotecontrol";
      module = "kdeutils";
    };
  };
}
