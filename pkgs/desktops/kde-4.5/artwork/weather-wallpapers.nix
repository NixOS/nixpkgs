{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-weather-wallpapers-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE wallpapers (weather)";
    kde = {
      name = "WeatherWallpapers";
      module = "kdeartwork";
      version = "4.5.2";
    };
  };
}
