{ kde, cmake, perl, kdelibs, qt4, automoc4, qimageblitz, python }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 qimageblitz python ];

  cmakeFlags = "-DBUILD_icons=TRUE -DBULD_plasma=TRUE";

  meta = {
    description = "A KDE Eye-candy Application";
    kde = {
      name = "superkaramba";
      module = "kdeutils";
      version = "0.55";
      release = "4.5.1";
    };
  };
}
