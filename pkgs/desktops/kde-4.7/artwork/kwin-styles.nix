{ cmake, kde, qt4, automoc4, kdelibs, phonon, kde_workspace }:

kde.package rec {
  buildInputs = [ cmake qt4 automoc4 kdelibs phonon kde_workspace ];

  meta = {
    description = "Styles for KWin";
    kde = {
      name = "kwin-styles";
      module = "kdeartwork";
    };
  };
}
