{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-wallpapers-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "Additional KDE wallpapers";
    kde = {
      name = "wallpapers";
      module = "kdeartwork";
    };
  };
}
