{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-desktop-themes-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "Additional KDE desktop themes";
    kde = {
      name = "desktopthemes";
      module = "kdeartwork";
    };
  };
}
