{ lib, fetchurl, libarchive }:

let
  version = "0.8.2";
in fetchurl {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "17xkpklb6spi10132lq658fwvrms3fs7ksb9j098z9vaqad1k51q";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    mkdir -p $out/share/fonts
    ${libarchive}/bin/bsdtar -xf $downloadedFile -C $out/share/fonts
  '';

  meta = with lib; {
    description = "SARASA GOTHIC is a Chinese & Japanese programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
  };
}
