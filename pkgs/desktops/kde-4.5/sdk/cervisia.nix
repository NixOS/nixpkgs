{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  meta = {
    description = "A KDE CVS frontend";
    kde = {
      name = "cervisia";
      module = "kdesdk";
      version = "3.5.0";
      release = "4.5.2";
      versionFile = "cervisia/version.h";
    };
  };
}
