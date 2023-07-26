{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "arkpandora";
  version = "2.04";

  src = fetchurl {
    urls = [
      "http://distcache.FreeBSD.org/ports-distfiles/ttf-arkpandora-${version}.tgz"
      "ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/ttf-arkpandora-${version}.tgz"
      "http://www.users.bigpond.net.au/gavindi/ttf-arkpandora-${version}.tgz"
    ];
    hash = "sha256-ofyVPJjQD8w+8WgETF2UcJlfbSsKQgBsH3ob+yjvrpo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Font, metrically identical to Arial and Times New Roman";
    license = lib.licenses.bitstreamVera;
  };
}
