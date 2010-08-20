{kdePackage, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4}:

kdePackage {
  pn = "kdetoys";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
  };
}
