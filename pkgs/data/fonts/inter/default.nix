# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "3.19";
in (fetchzip {
  name = "inter-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  sha256 = "sha256-8p15thg3xyvCA/8dH2jGQoc54nzESFDyv5m47FgWrSI=";

  meta = with lib; {
    homepage = "https://rsms.me/inter/";
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
})

