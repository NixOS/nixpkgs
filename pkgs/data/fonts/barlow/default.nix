# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:
let
  version = "1.422";
in
(fetchzip rec {
  name = "barlow-${version}";

  url = "https://tribby.com/fonts/barlow/download/barlow-${version}.zip";

  sha256 = "08ld4c3zq4d1px07lc64i7l8848zsc61ddy3654w2sh0hx5sm5ld";

  meta = with lib; {
    description = "A grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.eot -d $out/share/fonts/eot
    unzip -j $downloadedFile \*.woff -d $out/share/fonts/woff
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
  '';
})
