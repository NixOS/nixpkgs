{ kde, cmake, kdelibs, qt4, automoc4, phonon, boost, perl }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon boost perl ];

  NIX_CFLAGS_COMPILE = "-fexceptions";

  meta = {
    description = "A KDE graph theory viewer";
    kde = {
      name = "rocs";
    };
  };
}
