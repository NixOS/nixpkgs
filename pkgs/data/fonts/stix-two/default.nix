# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:
let
  version = "2.13";
in
(fetchzip {
  name = "stix-two-${version}";

  url = "https://github.com/stipub/stixfonts/raw/v${version}/zipfiles/STIX${builtins.replaceStrings [ "." ] [ "_" ] version}-all.zip";

  sha256 = "sha256-cBtZe/oq4bQCscSAhJ4YuTSghDleD9O/+3MHOJyI50o=";

  meta = with lib; {
    homepage = "https://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';
})
