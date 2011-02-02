{ kde, cmake, kdelibs, qt4, perl, automoc4, kdebase_workspace }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 kdebase_workspace ];

  meta = {
    description = "KDE remote control";
    kde = {
      name = "kremotecontrol";
      module = "kdeutils";
    };
  };
}
