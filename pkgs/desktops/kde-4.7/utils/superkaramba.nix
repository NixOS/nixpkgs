{ kde, cmake, kdelibs, qt4, automoc4, phonon, qimageblitz, python }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon qimageblitz ];

  cmakeFlags = "-DBUILD_icons=TRUE -DBULD_plasma=TRUE";

  meta = {
    description = "A KDE Eye-candy Application";
    kde = {
      name = "superkaramba";
      module = "kdeutils";
      version = "0.57";
      versionFile = "src/main.cpp";
    };
  };
}
