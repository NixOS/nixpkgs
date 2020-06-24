{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "stix-otf";
  version = "1.1.1";

  src = fetchzip {
    url = "http://ftp.fi.muni.cz/pub/linux/gentoo/distfiles/STIXv${version}-word.zip";
    sha256 = "0kqglki9wnp90idyn5k2l1hdjlkmfjavln864sy7hg4ixywr6x1k";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ rycee ];
  };
}
