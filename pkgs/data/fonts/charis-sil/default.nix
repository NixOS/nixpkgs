{ lib, fetchzip }:

let
  version = "5.000";
in
  fetchzip rec {
    name = "charis-sil-${version}";

    url = "https://software.sil.org/downloads/r/charis/CharisSIL-${version}.zip";

    postFetch = ''
      mkdir -p $out/share/{doc,fonts}
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*OFL.txt \*OFL-FAQ.txt \*README.txt \*FONTLOG.txt -d "$out/share/doc/${name}"
    '';

    sha256 = "1a220s8n0flvcdkazqf5g10v6r55s2an308slvvarynpj6l7x27n";

    meta = with lib; {
      homepage = https://software.sil.org/charis;
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
