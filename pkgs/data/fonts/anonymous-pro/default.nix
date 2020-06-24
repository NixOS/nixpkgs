{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "anonymousPro";
  version = "1.002";

  src = fetchzip {
    url = "http://www.marksimonson.com/assets/content/fonts/AnonymousPro-${version}.zip";
    sha256 = "0iadz9qvg1yykqps2mrfapp7ysff4w4r1bjcyj6p5wbjh1bv670n";
  };

  meta = with lib; {
    homepage = "https://www.marksimonson.com/fonts/view/anonymous-pro";
    description = "TrueType font set intended for source code";
    longDescription = ''
      Anonymous Pro (2009) is a family of four fixed-width fonts
      designed with coding in mind. Anonymous Pro features an
      international, Unicode-based character set, with support for
      most Western and Central European Latin-based languages, plus
      Greek and Cyrillic. It is designed by Mark Simonson.
    '';
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
