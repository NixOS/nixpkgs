{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "Various scripts to ease KDE development";
    kde = {
      name = "scripts";
      module = "kdesdk";
    };
  };
}
