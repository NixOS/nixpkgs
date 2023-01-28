{ lib, fetchurl }:

let
  version = "2.04";
in fetchurl {
  name = "arkpandora-${version}";

  urls = [
    "http://distcache.FreeBSD.org/ports-distfiles/ttf-arkpandora-${version}.tgz"
    "ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/ttf-arkpandora-${version}.tgz"
    "http://www.users.bigpond.net.au/gavindi/ttf-arkpandora-${version}.tgz"
  ];
  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
  sha256 = "177k0fbs0787al0snkl8w68d2qkg7snnnq6qp28j9s98vaabs04k";

  meta = {
    description = "Font, metrically identical to Arial and Times New Roman";
    license = lib.licenses.bitstreamVera;
  };
}
