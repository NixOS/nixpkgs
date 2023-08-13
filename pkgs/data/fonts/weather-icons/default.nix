{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "weather-icons";
  version = "2.0.12";

  src = fetchzip {
    url = "https://github.com/erikflowers/weather-icons/archive/refs/tags/${version}.zip";
    hash = "sha256-0ZFH2awUo4BkTpK1OsWZ4YKczJHo+HHM6ezGBJAmT+U=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 _docs/font-source/weathericons-regular.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

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
}
