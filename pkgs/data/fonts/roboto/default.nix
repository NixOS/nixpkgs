# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.138";
in (fetchzip {
  name = "roboto-${version}";

  url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";

  sha256 = "1s3c48wwvvwd3p4w3hfkri5v2c54j2bdxmd3bjv54klc5mrlh6z3";

  meta = {
    homepage = "https://github.com/google/roboto";
    description = "The Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -x __MACOSX/\* -d $out/share/fonts/truetype
  '';
})
