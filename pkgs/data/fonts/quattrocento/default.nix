# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "1.1";
  name = "quattrocento-${version}";
in (fetchzip rec {
  inherit name;

  url = "https://web.archive.org/web/20170707001804/http://www.impallari.com/media/releases/quattrocento-v${version}.zip";

  sha256 = "0f8l19y61y20sszn8ni8h9kgl0zy1gyzychg22z5k93ip4h7kfd0";

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocento/";
    description = "A classic, elegant, sober and strong serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/{fonts,doc}
    unzip -j $downloadedFile \*.otf        -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*FONTLOG.txt -d $out/share/doc/${name}
  '';
})
