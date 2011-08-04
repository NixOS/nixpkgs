{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "KDE Frontend for Callgrind/Cachegrind";
    kde = {
      name = "kcachegrind";
      module = "kdesdk";
      version = "0.6";
      versionFile = "CMakeLists.txt";
    };
  };
}
