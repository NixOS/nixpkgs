{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "Strigi analyzers for diff, po and ts";
    kde = {
      name = "strigi-analyzer";
      module = "kdesdk";
    };
  };
}
