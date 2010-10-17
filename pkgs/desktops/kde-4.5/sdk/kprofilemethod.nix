{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];


  meta = {
    description = "A macros for profiling using QTime";
    longDescription = "Don't commit any code using kprofilemethod.h to KDE repositories.";
    kde = {
      name = "kprofilemethod";
      module = "kdesdk";
      version = "4.5.2";
    };
  };
}
