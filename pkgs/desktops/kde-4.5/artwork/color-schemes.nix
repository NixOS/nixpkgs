{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-color-schemes-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE color schemes";
    kde = {
      name = "ColorSchemes";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
