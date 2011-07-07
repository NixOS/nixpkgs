{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-weather-wallpapers-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "Additional KDE wallpapers (weather)";
    kde = {
      name = "WeatherWallpapers";
      module = "kdeartwork";
    };
  };
}
