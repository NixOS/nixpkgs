# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

(fetchzip {
  name = "ipaexfont-004.01";

  url = "https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip";

  sha256 = "0wp369kri33kb1mmiq4lpl9i4xnacw9fj63ycmkmlkq64s8qnjnx";

  meta = with lib; {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAex font is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.

      This is the successor to the IPA fonts.
    '';
    homepage = "https://moji.or.jp/ipafont/";
    license = licenses.ipa;
    maintainers = with maintainers; [ gebner ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/opentype
  '';
})
