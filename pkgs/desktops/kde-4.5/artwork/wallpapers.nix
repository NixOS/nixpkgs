{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-wallpapers-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE wallpapers";
    kde = {
      name = "wallpapers";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
