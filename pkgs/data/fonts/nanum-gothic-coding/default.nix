{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "nanum-gothic-coding";
  version = "2.5";

  src = fetchzip {
    url = "https://github.com/naver/nanumfont/releases/download/VER${version}/NanumGothicCoding-${version}.zip";
    sha256 = "1mwijjnww477y9hv4b5r5z387h5g6xi037f280i9x7riql4dnxlc";
    stripRoot = false;
  };

  meta = with lib; {
    description = "A contemporary monospaced sans-serif typeface with a warm touch";
    homepage = "https://github.com/naver/nanumfont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ linarcx ];
  };
}
