{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "Various scripts to ease KDE development";
    kde = {
      name = "scripts";
      module = "kdesdk";
      version = "4.5.1";
    };
  };
}
