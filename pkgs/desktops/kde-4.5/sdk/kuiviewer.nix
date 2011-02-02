{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  meta = {
    description = "Displays Qt Designer's UI files";
    kde = {
      name = "kuiviewer";
      module = "kdesdk";
      version = "0.1";
      versionFile = "main.cpp";
    };
  };
}
