# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

# Source Sans Pro got renamed to Source Sans 3 (see
# https://github.com/adobe-fonts/source-sans/issues/192). This is the
# last version named "Pro". It is useful for backward compatibility
# with older documents/templates/etc.
let
  version = "3.006";
in (fetchzip {
  name = "source-sans-pro-${version}";

  url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";

  sha256 = "sha256-uWr/dFyLF65v0o6+oN/3RQoe4ziPspzGB1rgiBkoTYY=";

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
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
