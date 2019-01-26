{ lib, fetchzip }:

let
  version = "1.2.3";
in fetchzip rec {
  name = "ibm-plex-${version}";
  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
  sha256 = "16vmby2svr4q0lvsnrpxzmhkb6yv84x2jg6jccaj7x9vq56b4adg";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://www.ibm.com/plex/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
