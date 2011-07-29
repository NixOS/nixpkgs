{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, subversion, apr, aprutil }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi subversion apr aprutil ];

  patches = [ ./find-svn.patch ];
  cmakeFlags = "-DBUILD_kioslave=ON";

  meta = {
    description = "Subversion kioslave";
    kde = {
      name = "kioslave-svn";
      module = "kdesdk";
    };
  };
}
