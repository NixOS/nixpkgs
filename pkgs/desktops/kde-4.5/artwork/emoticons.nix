{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-emotion-icons-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE emotion icons (smiles)";
    kde = {
      name = "emoticons";
      module = "kdeartwork";
      version = "4.5.2";
    };
  };
}
