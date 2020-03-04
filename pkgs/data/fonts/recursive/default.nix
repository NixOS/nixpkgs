{ lib, fetchzip }:

let
  version = "1.042";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/${version}/Recursive-Beta_${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf   -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
  '';

  sha256 = "1zcrvnzwd39fim2jxa3by6jgdrx7fdp64iw2bd181iwzinv1yqsa";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
