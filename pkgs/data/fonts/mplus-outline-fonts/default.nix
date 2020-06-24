{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "mplus";
  version = "063a";

  src = fetchzip {
    url = "mirror://osdn/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";
    sha256 = "0nhxlmm9akz7r3ngilfl27dbmy4c327kk5br3ii7pps28zdym3j4";
  };

  meta = with lib; {
    description = "M+ Outline Fonts";
    homepage = "https://mplus-fonts.osdn.jp/about-en.html";
    license = licenses.mit;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
