{ lib, fetchzip }:

let
  version = "1.071";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/v${version}/ArrowType-Recursive-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0db410vcvgawb89f11l2v7w3b7l70wzlwwv8df3vnangl3mdv13z";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
