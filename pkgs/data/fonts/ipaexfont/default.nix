{ lib, mkFont, fetchzip }:

mkFont {
  pname = "ipaexfont";
  version = "003.01";

  src = fetchzip {
    url = "http://web.archive.org/web/20160616003021/http://dl.ipafont.ipa.go.jp/IPAexfont/IPAexfont00301.zip";
    sha256 = "1dh8vir0hzq0149xh7cka1wbvdb9arq56n1f0i8xkxivf84744kk";
  };

  meta = with lib; {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAex font is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.

      This is the successor to the IPA fonts.
    '';
    homepage = "http://ipafont.ipa.go.jp/";
    license = licenses.ipa;
    maintainers = with maintainers; [ gebner ];
  };
}
