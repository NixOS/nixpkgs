{ lib, fetchzip }:

let
  version = "1.3.0";
in fetchzip rec {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';
  sha256 = "1xjvxyp7h1f7m82800m3q71hksddh25c9a9vnr3r070ppi19s5fc";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
