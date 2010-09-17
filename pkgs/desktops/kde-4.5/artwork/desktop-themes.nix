{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-desktop-themes-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE desktop themes";
    kde = {
      name = "desktopthemes";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
