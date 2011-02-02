{ kde, cmake, kdelibs, automoc4, kdebase_workspace }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 kdebase_workspace ];

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
