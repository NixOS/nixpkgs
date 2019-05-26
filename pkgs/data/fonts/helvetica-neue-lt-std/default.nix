{ lib, fetchzip }:

let
  version = "2013.06.07"; # date of most recent file in distribution
in fetchzip rec {
  name = "helvetica-neue-lt-std-${version}";

  url = "http://www.ephifonts.com/downloads/helvetica-neue-lt-std.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile Helvetica\ Neue\ LT\ Std/\*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0ampp9vf9xw0sdppl4lb9i9h75ywljhdcqmzh45mx2x9m7h6xgg9";

  meta = {
    homepage = http://www.ephifonts.com/free-helvetica-font-helvetica-neue-lt-std.html;
    description = "Helvetica Neue LT Std font";
    longDescription = ''
      Helvetica Neue Lt Std is one of the most highly rated and complete
      fonts of all time. Developed in early 1983, this font has well
      camouflaged heights and weights. The structure of the word is uniform
      throughout all the characters.

      The legibility with Helvetica Neue LT Std is said to have improved as
      opposed to other fonts. The tail of it is much longer in this
      font. The numbers are well spaced and defined with high accuracy. The
      punctuation marks are heavily detailed as well.
    '';
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.all;
  };
}
