{ lib, fetchzip }:

let
  version = "5.1.3";

in fetchzip {
  name = "ibm-plex-${version}";

  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';

  sha256 = "0w07fkhav2lqdyki7ipnkpji5ngwarlhsyliy0ip7cd29x24ys5h";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
