{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  meta = {
    description = "Various scripts to ease KDE development";
    kde = {
      name = "scripts";
      module = "kdesdk";
    };
  };
}
