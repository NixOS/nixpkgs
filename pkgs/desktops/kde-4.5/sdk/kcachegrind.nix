{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

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
