{ lib, fetchurl, libarchive }:

let
  version = "0.32.9";
in fetchurl {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "0mwaj9dq26f36ddywjm7m0is1jml2kpmqm46b16c8avvr97c65z5";

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
