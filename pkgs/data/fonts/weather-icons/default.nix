{ lib, fetchzip }:

let
  version = "2.0.10";
in fetchzip {
  name = "weather-icons-${version}";

  url = "https://github.com/erikflowers/weather-icons/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile weather-icons-${version}/_docs/font-source/weathericons-regular.otf -d $out/share/fonts/opentype
  '';

  sha256 = "10zny9987wybq55sm803hrjkp33dq1lgmnxc15kssr8yb81g6qrl";

  meta = with lib; {
    description = "Weather Icons";
    longDescription = ''
      Weather Icons is the only icon font and CSS with 222 weather themed icons,
      ready to be dropped right into Bootstrap, or any project that needs high
      quality weather, maritime, and meteorological based icons!
    '';
    homepage = https://erikflowers.github.io/weather-icons/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ pnelson ];
  };
}
