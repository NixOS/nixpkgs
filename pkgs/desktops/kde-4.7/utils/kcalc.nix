{ kde, cmake, kdelibs, qt4, automoc4, phonon, gmp }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon gmp ];

  meta = {
    description = "KDE Calculator";
    kde = {
      name = "kcalc";
      module = "kdeutils";
      version = "2.9";
      versionFile = "version.h";
    };
  };
}
