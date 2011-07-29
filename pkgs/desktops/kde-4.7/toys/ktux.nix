{ kde, cmake, kdelibs, qt4, automoc4, phonon, kde_workspace }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon kde_workspace ];

  meta = {
    description = "Tux Screen Saver";
    kde = {
      name = "ktux";
      module = "kdetoys";
      version = "1.0.1";
      versionFile = "src/sprite.cpp";
    };
  };
}
