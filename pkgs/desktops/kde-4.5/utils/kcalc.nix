{ kde, cmake, perl, kdelibs, qt4, automoc4, gmp }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 gmp ];

  meta = {
    description = "KDE Calculator";
    kde = {
      name = "kcalc";
      module = "kdeutils";
      version = "2.7";
      release = "4.5.2";
      versionFile = "version.h";
    };
  };
}
