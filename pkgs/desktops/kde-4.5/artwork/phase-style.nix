{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-style-phase-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "KDE phase style. Clean classical look";
    kde = {
      name = "styles";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
