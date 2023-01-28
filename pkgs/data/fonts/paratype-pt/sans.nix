# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

(fetchzip {
  name = "paratype-pt-sans";

  urls = [
    "https://company.paratype.com/system/attachments/629/original/ptsans.zip"
    "http://rus.paratype.ru/system/attachments/629/original/ptsans.zip"
  ];

  sha256 = "01fkd417gv98jf3a6zyfi9w2dkqsbddy1vacga2672yf0kh1z1r0";

  meta = with lib; {
    homepage = "http://www.paratype.ru/public/";
    description = "An open Paratype font";

    license = "Open Paratype license";
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt -d $out/share/doc/paratype
  '';
})
