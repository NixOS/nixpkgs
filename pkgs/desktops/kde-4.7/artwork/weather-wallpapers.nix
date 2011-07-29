{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-weather-wallpapers-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "Additional KDE wallpapers (weather)";
    kde = {
      name = "WeatherWallpapers";
      module = "kdeartwork";
    };
  };
}
