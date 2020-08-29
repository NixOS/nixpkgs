{ lib, fetchzip }:

let
  version = "1.062";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/${version}/ArrowType-Recursive-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
  '';

  sha256 = "06qilfa0c897shh7m7rpwia02nay8cjwnizzzba27ylzy5pwd96r";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
