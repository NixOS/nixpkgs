{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "charis-sil";
  version = "5.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/charis/CharisSIL-${version}.zip";
    sha256 = "152182hmr9wmpffc54iqzjf9gww3rvbvkkcgmfd04ryq4rxnqmx6";
  };

  meta = with lib; {
    homepage = "https://software.sil.org/charis";
    description = "A family of highly readable fonts for broad multilingual use";
    longDescription = ''
    This Charis SIL font is essentially the same design as the SIL Charis font first released by SIL in 1997. Charis is similar to Bitstream Charter, one of the first fonts designed specifically for laser printers. It is highly readable and holds up well in less-than-ideal reproduction environments. It also has a full set of styles – regular, italic, bold, bold italic. Charis is a serif, proportionally-spaced font optimized for readability in long printed documents.

    The goal for this product was to provide a single Unicode-based font family that would contain a comprehensive inventory of glyphs needed for almost any Roman- or Cyrillic-based writing system, whether used for phonetic or orthographic needs. In addition, there is provision for other characters and symbols useful to linguists. This font makes use of state-of-the-art font technologies to support complex typographic issues, such as the need to position arbitrary combinations of base glyphs and diacritics optimally.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.f--t ];
  };
}
