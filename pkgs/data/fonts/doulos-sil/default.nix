{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "doulos-sil";
  version = "6.200";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/doulos/DoulosSIL-${version}.zip";
    hash = "sha256-kpbXJVAEQLr5HMFaE+8OgAYrMGQoetgMi0CcPn4a3Xw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL.txt OFL-FAQ.txt README.txt FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

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
