{ lib, fetchzip }:

let
  version = "1.0";
in fetchzip rec {
  name = "camingo-code-${version}";

  url = "https://github.com/chrissimpkins/codeface/releases/download/font-collection/codeface-fonts.zip";
  postFetch = ''
    install -Dm644 $out/camingo-code/*.ttf -t $out/share/fonts/truetype
    install -Dm644 $out/camingo-code/*.txt -t $out/share/doc/${name}
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';
  sha256 = "sha256-/vDNuR034stmiCZ9jUH5DlTQJn0WccLY5treoziXOJo=";

  meta = with lib; {
    homepage = "https://www.myfonts.com/fonts/jan-fromm/camingo-code/";
    description = "A monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
