{ stdenv, fetchzip }:

let
  version = "10.0.06";
in fetchzip rec {
  name = "unifont_upper-${version}";

  url = "http://unifoundry.com/pub/unifont-${version}/font-builds/${name}.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  sha256 = "13x5z8iyh9xz5fllcy89yinnz1iy16a2pjf3vip66nz10sq8crlr";

  meta = with stdenv.lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
