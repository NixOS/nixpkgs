{ lib, fetchzip }:

let
  version = "2.100";
in fetchzip rec {
  name = "scheherazade-${version}";

  url = "http://software.sil.org/downloads/r/scheherazade/Scheherazade-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -l $downloadedFile
    unzip -j $downloadedFile \*.ttf                        -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*/FONTLOG.txt  \*/README.txt -d $out/share/doc/${name}
    unzip -j $downloadedFile \*/documentation/\*           -d $out/share/doc/${name}/documentation
  '';

  sha256 = "1g5f5f9gzamkq3kqyf7vbzvl4rdj3wmjf6chdrbxksrm3rnb926z";

  meta = with lib; {
    homepage = https://software.sil.org/scheherazade/;
    description = "A font designed in a similar style to traditional Naskh typefaces";
    longDescription = ''
      Scheherazade, named after the heroine of the classic Arabian Nights tale,
      is designed in a similar style to traditional typefaces such as Monotype
      Naskh, extended to cover the Unicode Arabic repertoire through Unicode
      8.0.

      Scheherazade provides a “simplified” rendering of Arabic script, using
      basic connecting glyphs but not including a wide variety of additional
      ligatures or contextual alternates (only the required lam-alef
      ligatures). This simplified style is often preferred for clarity,
      especially in non-Arabic languages, but may not be considered appropriate
      in situations where a more elaborate style of calligraphy is preferred.

      This package contains the regular and bold styles for the Scheherazade
      font family, along with documentation.
    '';
    downloadPage = "https://software.sil.org/scheherazade/download/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
