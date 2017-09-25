{ stdenv, fetchzip }:

let
  version = "9.0.03";
in fetchzip rec {
  name = "unifont_upper-${version}";

  url = "http://unifoundry.com/pub/unifont-${version}/font-builds/${name}.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  sha256 = "0anja3wrdjw0czqqk6wpf9yrkp0b11hb98wzmrpyij9gfgrspd71";

  meta = with stdenv.lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
