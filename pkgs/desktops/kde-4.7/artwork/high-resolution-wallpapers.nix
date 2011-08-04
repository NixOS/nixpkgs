{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-wallpapers-high-resolution-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];
  
  meta = {
    description = "KDE wallpapers in high resolution";
    kde = {
      name = "HighResolutionWallpapers";
      module = "kdeartwork";
    };
  };
}
