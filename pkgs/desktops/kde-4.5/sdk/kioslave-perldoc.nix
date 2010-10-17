{ kde, cmake, kdelibs, automoc4, perl }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 perl ];

  cmakeFlags = "-DBUILD_kioslave=ON -DBUILD_perldoc=ON";

  meta = {
    description = "perldoc: kioslave";
    kde = {
      name = "kioslave-perldoc";
      module = "kdesdk";
      version = "0.9.1";
      release = "4.5.2";
      versionFile = "kioslave/perldoc/perldoc.cpp";
    };
  };
}
