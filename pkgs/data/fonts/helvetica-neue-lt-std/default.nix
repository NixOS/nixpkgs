{ lib, mkFont, fetchzip }:

mkFont {
  pname = "helvetica-neue-lt-std";
  version = "2013-06-07";

  src = fetchzip {
    url = "http://www.ephifonts.com/downloads/helvetica-neue-lt-std.zip";
    sha256 = "14nmv495fbzy3jqivk2nbssvw2j40cpca4zqqd65jdzhp5717nna";
    stripRoot = false;
  };

  meta = {
    homepage = "http://www.ephifonts.com/free-helvetica-font-helvetica-neue-lt-std.html";
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
