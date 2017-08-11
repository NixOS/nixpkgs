{ stdenv, fetchzip }:

let
  version = "1.0";
in fetchzip rec {
  name = "camingo-code-${version}";

  url = https://github.com/chrissimpkins/codeface/releases/download/font-collection/codeface-fonts.zip;
  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v fonts/camingo-code/*.ttf $out/share/fonts/truetype/
    cp -v fonts/camingo-code/*.txt $out/share/doc/${name}/
  '';
  sha256 = "035z2k6lwwy2bysw27pirn3vjxnj2h23nyx8jr213rb2bl0m21x1";

  meta = with stdenv.lib; {
    homepage = https://www.myfonts.com/fonts/jan-fromm/camingo-code/;
    description = "A monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
