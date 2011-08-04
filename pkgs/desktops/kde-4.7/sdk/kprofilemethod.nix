{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "A macro for profiling using QTime";
    kde = {
      name = "kprofilemethod";
      module = "kdesdk";
    };
  };
}
