{ lib, fetchFromGitHub }:

let
  version = "3.0.1";
in fetchFromGitHub {
  name = "material-icons-${version}";

  owner  = "google";
  repo   = "material-design-icons";
  rev    = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype
    cp iconfont/*.ttf $out/share/fonts/truetype
  '';
  sha256 = "1syy6v941lb8nqxhdf7mfx28v05lwrfnq53r3c1ym13x05l9kchp";

  meta = with lib; {
    description = "System status icons by Google, featuring material design";
    homepage = https://material.io/icons;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mpcsh ];
  };
}
