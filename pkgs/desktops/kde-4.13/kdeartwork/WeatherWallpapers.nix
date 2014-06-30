{ kde, kdelibs }:

kde rec {
  name = "kde-weather-wallpapers";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE wallpapers (weather)";
  };
}
