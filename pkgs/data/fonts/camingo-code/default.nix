{ lib, mkFont, fetchzip }:

mkFont {
  pname = "camingo-code";
  version = "1.0";

  src = fetchzip {
    url = "https://janfromm.de/_data/downloads/CamingoCode-v1.0.zip";
    sha256 = "1skmw445ziizw28v1da8194gs2icrqrrl3s069sghfd7ynwkwm3h";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://www.janfromm.de/typefaces/camingomono/camingocode/";
    description = "A monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
