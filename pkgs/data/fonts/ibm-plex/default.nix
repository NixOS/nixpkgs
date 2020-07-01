{ lib, fetchzip }:

let
  version = "5.0.0";

in fetchzip {
  name = "ibm-plex-${version}";

  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -d $out/share/fonts/opentype
  '';

  sha256 = "1m8a9p0bryrj05v7sg9kqvyp0ddhgdwd0zjbn0i4l296cj5s2k97";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
