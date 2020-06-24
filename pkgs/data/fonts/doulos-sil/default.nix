{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "doulos-sil";
  version = "5.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/doulos/DoulosSIL-${version}.zip";
    sha256 = "1zxkixa6is4yb8h6icmjlb3im20msw5f7mc5ihzbvzhi1k4s1ymb";
  };

  meta = with lib; {
    homepage = "https://software.sil.org/doulos";
    description = "A font that provides complete support for the International Phonetic Alphabet";
    longDescription = ''
    This Doulos SIL font is essentially the same design as the SIL Doulos font first released by SIL in 1992. The design has been changed from the original in that it has been scaled down to be a better match with contemporary digital fonts, such as Times New Roman®. This current release is a regular typeface, with no bold or italic version available or planned. It is intended for use alongside other Times-like fonts where a range of styles (italic, bold) are not needed. Therefore, just one font is included in the Doulos SIL release: Doulos SIL Regular.

    The goal for this product was to provide a single Unicode-based font family that would contain a comprehensive inventory of glyphs needed for almost any Roman- or Cyrillic-based writing system, whether used for phonetic or orthographic needs. In addition, there is provision for other characters and symbols useful to linguists. This font makes use of state-of-the-art font technologies to support complex typographic issues, such as the need to position arbitrary combinations of base glyphs and diacritics optimally.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.f--t ];
  };
}
