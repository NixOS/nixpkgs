{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-color-schemes-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];
  
  meta = {
    description = "Additional KDE color schemes";
    kde = {
      name = "ColorSchemes";
      module = "kdeartwork";
    };
  };
}
