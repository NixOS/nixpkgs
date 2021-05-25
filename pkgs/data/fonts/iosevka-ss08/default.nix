{ lib, fetchzip }:

let
  version = "6.1.3";
in

fetchzip rec {
  name = "ttf-iosevka-ss08-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/${name}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf    -d $out/share/fonts/Iosevka-SS08
  '';

  sha256 = "nkmMsSBrkvTDfQQdJ0XXh4z5TapP1pEdYmMlgLhkm5A=";

  meta = with lib; {
    homepage = "https://github.com/be5invis/Iosevka";
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.wearemnr ];
  };
}
