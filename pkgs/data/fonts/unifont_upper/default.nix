{ lib, fetchzip }:

let
  version = "13.0.04";
in fetchzip rec {
  name = "unifont_upper-${version}";

  url = "mirror://gnu/unifont/unifont-${version}/${name}.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/unifont_upper.ttf";

  sha256 = "0bji0crx84nbjf1m1lzql7icrb02zbs3l66dn21pvr9czsry870f";

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = "http://unifoundry.com/unifont.html";

    # Basically GPL2+ with font exception.
    license = "http://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
