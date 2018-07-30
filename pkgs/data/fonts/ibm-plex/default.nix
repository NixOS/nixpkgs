{ lib, fetchzip }:

let
  version = "1.0.2";
in fetchzip rec {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
  sha256 = "1ixxm47lwsrc136z6cxkk5dm3svmvcvq0ya8q8ayvn68q5ijbh5m";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
