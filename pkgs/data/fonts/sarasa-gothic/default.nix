{ lib, fetchurl, libarchive }:

let
  version = "0.34.7";
in fetchurl {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttf-${version}.7z";
  sha256 = "094sl6gklrdv9pk4r6451dvz0fjyjmwys7i81qrz4ik1km5dfq9b";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    ${libarchive}/bin/bsdtar -xf $downloadedFile -C $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A CJK programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    platforms = platforms.all;
  };
}
