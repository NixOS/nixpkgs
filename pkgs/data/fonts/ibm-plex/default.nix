{ lib, fetchzip }:

let
  version = "4.0.1";
in fetchzip {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';
  sha256 = "11d5bsv7d5rbp9f1gf1l4za3xj6jlqwnvsl5ipwx4angh1kb7nk8";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
