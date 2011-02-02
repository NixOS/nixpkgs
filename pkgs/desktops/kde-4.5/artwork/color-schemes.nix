{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-color-schemes-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE color schemes";
    kde = {
      name = "ColorSchemes";
      module = "kdeartwork";
    };
  };
}
