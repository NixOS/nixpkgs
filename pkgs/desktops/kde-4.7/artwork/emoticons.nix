{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-emotion-icons-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "Additional KDE emotion icons (smiles)";
    kde = {
      name = "emoticons";
      module = "kdeartwork";
    };
  };
}
