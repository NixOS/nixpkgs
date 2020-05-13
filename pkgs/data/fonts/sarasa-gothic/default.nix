{ lib, fetchurl, libarchive }:

let
  version = "0.12.6";
in fetchurl {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "1b15gsmv2jr0r8xssr8216s8xsghr6w5wm3w3imm3qlh3kqk1qg8";

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
