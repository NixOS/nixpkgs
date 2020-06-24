{ mkFont, fetchurl }:

mkFont rec {
  pname = "arkpandora";
  version = "2.04";

  src = fetchurl {
    urls = [
      "http://distcache.FreeBSD.org/ports-distfiles/ttf-arkpandora-${version}.tgz"
      "ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/ttf-arkpandora-${version}.tgz"
      "http://www.users.bigpond.net.au/gavindi/ttf-arkpandora-${version}.tgz"
    ];
    sha256 = "16mfxwlgn6vs3xn00hha5dnmz6bhjiflq138y4zcq3yhk0y9bz51";
  };

  meta = {
    description = "Font, metrically identical to Arial and Times New Roman";
  };
}
