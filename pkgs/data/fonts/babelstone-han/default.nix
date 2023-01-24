# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "13.0.3";
in (fetchzip {
  name = "babelstone-han-${version}";

  # upstream download links are unversioned, so hash changes
  url = "https://web.archive.org/web/20200210125314/https://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip";
  sha256 = "018isk3hbzsihzrxavgjbn485ngzvlm96npqx9y7zpkxsssslc4w";

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";

    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ emily ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
})
