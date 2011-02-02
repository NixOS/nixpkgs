{ kde, cmake, perl, kdelibs, qt4, automoc4, gmp }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 gmp ];

  meta = {
    description = "KDE Calculator";
    kde = {
      name = "kcalc";
      module = "kdeutils";
      version = "2.7";
      versionFile = "version.h";
    };
  };
}
