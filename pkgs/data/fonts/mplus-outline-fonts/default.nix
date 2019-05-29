{ lib, fetchzip }:

let
  version = "063a";
in fetchzip rec {
  name = "mplus-${version}";

  url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "1khbkch2r96ppifc93bmy1v047pgciyhfmcjb98ggncp5ix885xz";

  meta = with lib; {
    description = "M+ Outline Fonts";
    homepage = http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index-en.html;
    license = licenses.mit;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
