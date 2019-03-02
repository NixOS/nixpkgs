{ stdenv, fetchzip }:

let
  version = "11.0.03";
in fetchzip rec {
  name = "unifont_upper-${version}";

  url = "mirror://gnu/unifont/unifont-${version}/${name}.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  sha256 = "1gfjv3n9pxwzla4pil518a80ihn5wz0c7d4mhfw0dj2n5fwgpdmr";

  meta = with stdenv.lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
