{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-wallpapers-high-resolution-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "KDE wallpapers in high resolution";
    kde = {
      name = "HighResolutionWallpapers";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
