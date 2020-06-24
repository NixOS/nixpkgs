{ lib, mkFont, fetchzip }:

mkFont rec {
  name = "quattrocento-sans";
  version = "2.0";

  src = fetchzip {
    url = "http://web.archive.org/web/20170709124317/http://www.impallari.com/media/releases/quattrocento-sans-v${version}.zip";
    sha256 = "1jlynv2mamqizpiin4mpa8i1r6h6sb3afv7w01yq1xw0crk8axig";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocentosans/";
    description = "A classic, elegant and sober sans-serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ rycee ];
  };
}
