{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-style-phase-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "Phase, a widget style for KDE";
    kde = {
      name = "styles";
      module = "kdeartwork";
    };
  };
}
