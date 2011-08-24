{ kde, cmake, kdelibs, automoc4, libxml2, libxslt }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt ];

  meta = {
    description = "A graphical editor of scripted dialogs";
    kde = {
      name = "kommander";
      module = "kdewebdev";
      versionFile = "lib/kommanderversion.h";
    };
  };
}
