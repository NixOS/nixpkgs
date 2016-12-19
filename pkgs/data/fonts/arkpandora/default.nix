{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "arkpandora-${version}";
  version = "2.04";

  src = fetchurl {
    urls = [
      "ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/ttf-arkpandora-${version}.tgz"
      "http://distcache.FreeBSD.org/ports-distfiles/ttf-arkpandora-${version}.tgz"
      "http://www.users.bigpond.net.au/gavindi/ttf-arkpandora-${version}.tgz"
      ];
    sha256 = "16mfxwlgn6vs3xn00hha5dnmz6bhjiflq138y4zcq3yhk0y9bz51";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Font, metrically identical to Arial and Times New Roman";
    platforms = stdenv.lib.platforms.unix;
  };
}
