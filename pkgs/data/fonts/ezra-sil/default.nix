# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.51";
  name = "ezra-sil-${version}";
in
  (fetchzip rec {
    inherit name;

    url = "https://software.sil.org/downloads/r/ezra/EzraSIL-${version}.zip";

    sha256 = "sha256-1LGw/RPFeNtEvcBWFWZf8+dABvWye2RfZ/jt8rwQewM=";

    meta = with lib; {
      homepage = "https://software.sil.org/ezra";
      description = "Typeface fashioned after the square letter forms of the typography of the Biblia Hebraica Stuttgartensia (BHS)";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [ maintainers.kmein ];
    };
  }).overrideAttrs (_: {
    postFetch = ''
      mkdir -p $out/share/{doc,fonts}
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*OFL-FAQ.txt \*README.txt \*FONTLOG.txt -d "$out/share/doc/${name}"
    '';
  })
