{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-emotion-icons-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE emotion icons (smiles)";
    kde = {
      name = "emoticons";
      module = "kdeartwork";
    };
  };
}
