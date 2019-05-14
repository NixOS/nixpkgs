{ lib, fetchzip }:

let
  version = "063";
in fetchzip rec {
  name = "mplus-${version}";

  url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "0d485l2ihxfk039rrrnfviamlbj13cwky0c752m4ikwvgiqiq94y";

  meta = with lib; {
    description = "M+ Outline Fonts";
    homepage = http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index-en.html;
    license = licenses.mit;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
