{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "nuvola-icon-theme-${kde.release}";
  
  # Sources contain primary and kdeclassic as well but they're not installed

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];
  
  meta = {
    description = "KDE nuvola icon theme";
    kde = {
      name = "IconThemes";
      module = "kdeartwork";
    };
  };
}
