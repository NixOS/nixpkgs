{ lib, fetchzip }:

let
  version = "12.1.01";
in fetchzip rec {
  name = "unifont_upper-${version}";

  url = "mirror://gnu/unifont/unifont-${version}/${name}.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  sha256 = "11b14ka2w16vssxdhgq7k9bx7xx0sr36hfi2vzyimmaibasi1r74";

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
