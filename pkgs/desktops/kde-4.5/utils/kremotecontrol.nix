{ kde, cmake, kdelibs, qt4, perl, automoc4, kdebase_workspace }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 kdebase_workspace ];

  meta = {
    description = "";
    kde = {
      name = "kremotecontrol";
      module = "kdeutils";
      version = "4.5.0";
      release = "4.5.0";
    };
  };
}
