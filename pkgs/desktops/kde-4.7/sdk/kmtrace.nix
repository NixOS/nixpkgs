{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, gcc }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  preConfigure = "export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${gcc}:${gcc.gcc}";

  meta = {
    description = "KDE mtrace-based malloc debugger";
    kde = {
      name = "kmtrace";
      module = "kdesdk";
    };
  };
}
