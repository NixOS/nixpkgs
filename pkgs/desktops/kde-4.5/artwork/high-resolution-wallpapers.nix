{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-wallpapers-high-resolution-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "KDE wallpapers in high resolution";
    kde = {
      name = "HighResolutionWallpapers";
      module = "kdeartwork";
    };
  };
}
