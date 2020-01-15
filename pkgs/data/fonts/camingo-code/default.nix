{ lib, fetchzip }:

let
  version = "1.0";
in fetchzip rec {
  name = "camingo-code-${version}";

  url = https://github.com/chrissimpkins/codeface/releases/download/font-collection/codeface-fonts.zip;
  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype fonts/camingo-code/*.ttf
    install -m444 -Dt $out/share/doc/${name}    fonts/camingo-code/*.txt
  '';
  sha256 = "16iqjwwa7pnswvcc4w8nglkd0m0fz50qsz96i1kcpqip3nwwvw7y";

  meta = with lib; {
    homepage = https://www.myfonts.com/fonts/jan-fromm/camingo-code/;
    description = "A monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
