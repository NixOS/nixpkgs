{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-desktop-themes-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE desktop themes";
    kde = {
      name = "desktopthemes";
      module = "kdeartwork";
    };
  };
}
