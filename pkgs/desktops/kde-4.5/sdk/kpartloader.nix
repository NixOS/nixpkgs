{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];


  meta = {
    description = "A test application for KParts";
    kde = {
      name = "kpartloader";
      module = "kdesdk";
      version = "1.0";
      release = "4.5.2";
      versionFile = "kpartloader.cpp";
    };
  };
}
