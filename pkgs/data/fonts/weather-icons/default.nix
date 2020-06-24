{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "weather-icons";
  version = "2.0.10";

  src = fetchzip {
    url = "https://github.com/erikflowers/weather-icons/archive/${version}.zip";
    sha256 = "0fz9mbrd4s7w8rahda51jascrjkiyprnir39k9d56cni90pvcvbs";
  };

  sourceRoot = "source/font";

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
