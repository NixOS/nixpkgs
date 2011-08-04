{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, antlr }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi antlr ];

  meta = {
    description = "Po<->xml tools";
    kde = {
      name = "poxml";
      module = "kdesdk";
    };
  };
}
