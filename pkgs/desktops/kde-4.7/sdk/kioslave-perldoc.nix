{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, perl }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi perl ];

  cmakeFlags = "-DBUILD_kioslave=ON -DBUILD_perldoc=ON";

  meta = {
    description = "perldoc: kioslave";
    kde = {
      name = "kioslave-perldoc";
      module = "kdesdk";
      version = "0.9.1";
      versionFile = "kioslave/perldoc/perldoc.cpp";
    };
  };
}
