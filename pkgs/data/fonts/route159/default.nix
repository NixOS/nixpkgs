{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "route159";
  version = "1.10";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "0dd58yjiy4awhj9xa9giqkf1cpjgmzcrgsjg45zvl6abdl2z52fl";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://dotcolon.net/font/${pname}/";
    description = "A weighted sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
