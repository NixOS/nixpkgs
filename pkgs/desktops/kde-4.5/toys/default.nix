{kde, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4}:

kde.package {

  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    kde = {
      name = "kdetoys";
      version = "4.5.0";
    };
  };
}
