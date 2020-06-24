{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "quattrocento";
  version = "1.1";

  src = fetchzip {
    url = "http://web.archive.org/web/20170707001804/http://www.impallari.com/media/releases/quattrocento-v${version}.zip";
    sha256 = "1l9f9xkwi4zjxv4lpxikia1mbv3l4qzwhk1895xw28wkbrd3mmly";
  };

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocento/";
    description = "A classic, elegant, sober and strong serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
