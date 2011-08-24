{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-wallpapers-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE wallpapers";
    kde = {
      name = "wallpapers";
      module = "kdeartwork";
    };
  };
}
