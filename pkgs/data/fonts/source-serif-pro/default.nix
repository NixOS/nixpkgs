# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

# Source Serif Pro got renamed to Source Serif 4 (see
# https://github.com/adobe-fonts/source-serif/issues/77). This is the
# last version named "Pro". It is useful for backward compatibility
# with older documents/templates/etc.
let
  version = "3.001";
in (fetchzip {
  name = "source-serif-pro-${version}";

  url = "https://github.com/adobe-fonts/source-serif/releases/download/${version}R/source-serif-pro-${version}R.zip";

  sha256 = "sha256-rYWk8D41QMuuSP+cQMk8ttT7uX3a7gBk4OqjA7K9udk=";

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-serif/";
    description = "Typeface for setting text in many sizes, weights, and languages. Designed to complement Source Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';
})
