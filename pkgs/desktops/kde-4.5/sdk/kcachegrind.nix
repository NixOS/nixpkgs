{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "KDE Frontend for Callgrind/Cachegrind";
    kde = {
      name = "kcachegrind";
      module = "kdesdk";
      version = "0.6";
      release = "4.5.1";
    };
  };
}
