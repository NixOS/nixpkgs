{ lib, fetchurl }:

let
  version = "14.0.04";
in fetchurl rec {
  name = "unifont_upper-${version}";

  url = "mirror://gnu/unifont/unifont-${version}/${name}.ttf";

  downloadToTemp = true;

  recursiveHash = true;

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  hash = "sha256-cNw+3Y/6h2TD6ZSaGO32NNyiTwCUSJsA3Q5W5/m+eLE=";

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
