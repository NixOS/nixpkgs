{ kde, cmake, kdelibs, automoc4, gcc }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  preConfigure="export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${gcc}:${gcc.gcc}";

  meta = {
    description = "KDE mtrace-based malloc debuger";
    kde = {
      name = "kmtrace";
      module = "kdesdk";
      version = "4.5.2";
    };
  };
}
