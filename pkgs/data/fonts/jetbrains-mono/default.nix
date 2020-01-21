{ lib, fetchzip }:

let
  version = "1.0.1";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/${version}/JetBrainsMono-${version}.zip";

  sha256 = "15a8fwyg8ns6krq6nsvgn41iaqbd3lgm3cmv7w370gr6brbn6lxq";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ttf/*.ttf
    install -m444 -Dt $out/share/fonts/woff/ web/woff/*.woff
    install -m444 -Dt $out/share/fonts/woff2/ web/woff2/*.woff2
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
