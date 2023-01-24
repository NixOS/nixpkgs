# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.0.12";
in (fetchzip {
  name = "weather-icons-${version}";

  url = "https://github.com/erikflowers/weather-icons/archive/refs/tags/${version}.zip";
  sha256 = "sha256-NGPzAloeZa1nCazb+mjAbYw7ZYYDoKpLwcvzg1Ly9oM=";

  meta = with lib; {
    description = "Weather Icons";
    longDescription = ''
      Weather Icons is the only icon font and CSS with 222 weather themed icons,
      ready to be dropped right into Bootstrap, or any project that needs high
      quality weather, maritime, and meteorological based icons!
    '';
    homepage = "https://erikflowers.github.io/weather-icons/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ pnelson ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile weather-icons-${version}/_docs/font-source/weathericons-regular.otf -d $out/share/fonts/opentype
  '';
})
