{ lib, fetchzip }:

let
  version = "1.2.1";
in fetchzip rec {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
  sha256 = "1mwlw39nbqrk08crvgm77l98yyyabwhcgsng89c9s67gq4mlxmxa";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
