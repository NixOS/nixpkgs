{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "gentium-book-basic";
  version = "1.102";

  src = fetchzip {
    url = "http://software.sil.org/downloads/r/gentium/GentiumBasic_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "109yiqwdfb1bn7d6bjp8d50k1h3z3kz86p3faz11f9acvsbsjad0";
  };

  meta = with lib; {
    homepage = "https://software.sil.org/gentium/";
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = with maintainers; [ ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
