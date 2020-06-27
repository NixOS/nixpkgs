{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "gentium";
  version = "5.000";

  src = fetchzip {
    url = "http://software.sil.org/downloads/r/gentium/GentiumPlus-${version}.zip";
    sha256 = "0g9sx38wh7f0m16gr64g2xggjwak2q6jw9y4zhrvhmp4aq4xfqm6";
  };

  meta = with lib; {
    homepage = "https://software.sil.org/gentium/";
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    longDescription = ''
      Gentium is a typeface family designed to enable the diverse ethnic groups
      around the world who use the Latin, Cyrillic and Greek scripts to produce
      readable, high-quality publications. It supports a wide range of Latin and
      Cyrillic-based alphabets.

      The design is intended to be highly readable, reasonably compact, and
      visually attractive. The additional ‘extended’ Latin letters are designed
      to naturally harmonize with the traditional 26 ones. Diacritics are
      treated with careful thought and attention to their use. Gentium Plus also
      supports both polytonic and monotonic Greek.

      This package contains the regular and italic styles for the Gentium Plus
      font family, along with documentation.
    '';
    downloadPage = "https://software.sil.org/gentium/download/";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
