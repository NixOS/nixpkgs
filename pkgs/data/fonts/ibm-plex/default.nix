{ lib, fetchzip }:

let
  version = "5.1.0";

in fetchzip {
  name = "ibm-plex-${version}";

  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';

  sha256 = "1lcbj6zkpnsq38s2xkx3z4d7bd43k630lmzmgdcv1w05gjij0pw5";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
