{ stdenv, fetchzip }:

let
  version = "062";
in fetchzip rec {
  name = "mplus-${version}";

  url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "0zm1snq5r584rz90yv5lndsqgchdaxq2185vrk7849ch4k5vd23z";

  meta = with stdenv.lib; {
    description = "M+ Outline Fonts";
    homepage = http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index-en.html;
    license = licenses.mit;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
