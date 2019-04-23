{ lib, fetchzip }:

let
  version = "1.4.1";
in fetchzip rec {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';
  sha256 = "1y2p0gf8znryfcidg26dn9xi81wl9vq5m56ylvg5jp0sn971r4xq";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
