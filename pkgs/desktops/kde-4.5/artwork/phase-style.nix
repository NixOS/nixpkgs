{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-style-phase-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "KDE phase style. Clean classical look";
    kde = {
      name = "styles";
      module = "kdeartwork";
    };
  };
}
